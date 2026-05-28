-- Drop dead table
DROP TABLE IF EXISTS public.feed_items;

-- Fix views: add security_invoker to prevent RLS bypass
DROP VIEW IF EXISTS public.v_places_with_coverage CASCADE;
DROP VIEW IF EXISTS public.v_user_stamp_stats CASCADE;

CREATE VIEW public.v_places_with_coverage
WITH (security_invoker = on) AS
  SELECT p.*, pc.total_submissions, pc.accepted_submissions,
         pc.unique_submitters, pc.has_daytime, pc.has_nighttime,
         pc.rejection_rate, pc.needs_review
  FROM public.places p
  LEFT JOIN public.place_coverage pc ON p.id = pc.place_id;

CREATE VIEW public.v_user_stamp_stats
WITH (security_invoker = on) AS
  SELECT user_id,
         count(*)                                      AS total_stamps,
         count(*) FILTER (WHERE tier = 'tier1')        AS tier1_count,
         count(*) FILTER (WHERE tier = 'tier2')        AS tier2_count,
         count(distinct place_id)                      AS unique_places,
         count(distinct date_trunc('day', created_at)) AS active_days
  FROM public.stamps
  GROUP BY user_id;

-- Recreate places_within_radius after CASCADE dropped it
CREATE OR REPLACE FUNCTION public.places_within_radius(
  user_lat double precision,
  user_lng double precision,
  radius_m double precision DEFAULT 500
)
RETURNS SETOF v_places_with_coverage
LANGUAGE sql STABLE AS $$
  SELECT *
  FROM public.v_places_with_coverage
  WHERE ST_DWithin(
    geo::geography,
    ST_SetSRID(ST_MakePoint(user_lng, user_lat), 4326)::geography,
    radius_m
  )
  ORDER BY ST_Distance(
    geo::geography,
    ST_SetSRID(ST_MakePoint(user_lng, user_lat), 4326)::geography
  );
$$;

-- Fix UPDATE policies: add WITH CHECK to prevent row reassignment
DROP POLICY IF EXISTS "profiles_update" ON public.profiles;
CREATE POLICY "profiles_update" ON public.profiles FOR UPDATE
  TO authenticated
  USING  ((select auth.uid()) = id)
  WITH CHECK ((select auth.uid()) = id);

DROP POLICY IF EXISTS "stamps_update" ON public.stamps;
CREATE POLICY "stamps_update" ON public.stamps FOR UPDATE
  TO authenticated
  USING  ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);

-- Fix user_badges: only service_role (edge functions) may award badges
DROP POLICY IF EXISTS "user_badges_insert" ON public.user_badges;

-- Add status constraint on place_submissions
ALTER TABLE public.place_submissions
  ADD CONSTRAINT IF NOT EXISTS place_submissions_status_check
  CHECK (status IN ('pending','accepted','rejected'));

-- Fix function search_path (prevents search_path injection attacks)
CREATE OR REPLACE FUNCTION public.check_and_confirm_place(p_place_id uuid)
RETURNS void LANGUAGE plpgsql SET search_path = '' AS $$
declare
  cov public.place_coverage;
begin
  select * into cov from public.place_coverage where place_id = p_place_id;
  if cov.unique_submitters >= 3
    and cov.viewpoint_clusters >= 3
    and cov.has_daytime
    and cov.has_nighttime
    and (cov.rejection_rate is null or cov.rejection_rate < 0.5)
  then
    update public.places
    set status = 'confirmed', updated_at = now()
    where id = p_place_id;
  end if;
end;
$$;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
begin
  insert into public.profiles (id, username, display_name, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'preferred_username',
             split_part(new.email, '@', 1)),
    coalesce(new.raw_user_meta_data->>'full_name',
             new.raw_user_meta_data->>'name'),
    new.raw_user_meta_data->>'avatar_url'
  );
  insert into public.user_privacy (user_id) values (new.id);
  return new;
end;
$$;

-- handle_new_user is a trigger — should never be callable via REST API
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM PUBLIC;

CREATE OR REPLACE FUNCTION public.update_profile_badge_count()
RETURNS trigger LANGUAGE plpgsql SET search_path = '' AS $$
begin
  if TG_OP = 'INSERT' then
    update public.profiles set badge_count = badge_count + 1 where id = NEW.user_id;
  end if;
  return null;
end;
$$;

CREATE OR REPLACE FUNCTION public.update_stamp_like_count()
RETURNS trigger LANGUAGE plpgsql SET search_path = '' AS $$
begin
  if TG_OP = 'INSERT' then
    update public.stamps set like_count = like_count + 1 where id = NEW.stamp_id;
  elsif TG_OP = 'DELETE' then
    update public.stamps set like_count = like_count - 1 where id = OLD.stamp_id;
  end if;
  return null;
end;
$$;

-- places_within_radius: search_path = public needed for PostGIS types
CREATE OR REPLACE FUNCTION public.places_within_radius(
  user_lat double precision,
  user_lng double precision,
  radius_m double precision DEFAULT 500
)
RETURNS SETOF public.v_places_with_coverage
LANGUAGE sql STABLE SET search_path = public AS $$
  SELECT *
  FROM public.v_places_with_coverage
  WHERE ST_DWithin(
    geo::geography,
    ST_SetSRID(ST_MakePoint(user_lng, user_lat), 4326)::geography,
    radius_m
  )
  ORDER BY ST_Distance(
    geo::geography,
    ST_SetSRID(ST_MakePoint(user_lng, user_lat), 4326)::geography
  );
$$;
