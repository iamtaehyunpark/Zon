-- ============================================================
-- ZON — Supabase Database Schema  (copy-paste into SQL Editor)
-- ============================================================

-- Extensions
create extension if not exists "uuid-ossp";
create extension if not exists "postgis";
create extension if not exists "vector";

-- ============================================================
-- ENUMS
-- ============================================================

create type auth_tier   as enum ('tier1', 'tier2', 'tier3');
create type place_status as enum ('pending', 'confirmed', 'external');
create type space_type   as enum (
  'outdoor_artificial', 'outdoor_natural',
  'indoor_artificial',  'indoor_natural'
);
create type badge_type as enum (
  'place_signature', 'seasonal', 'pioneer',
  'founder', 'confirmer', 'quest', 'brand'
);
create type visibility as enum ('public', 'friends', 'private');

-- ============================================================
-- PROFILES  (extends auth.users)
-- ============================================================

create table public.profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  username        text unique not null,
  display_name    text,
  avatar_url      text,
  bio             text,
  country_count   int not null default 0,
  place_count     int not null default 0,
  badge_count     int not null default 0,
  follower_count  int not null default 0,
  following_count int not null default 0,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

alter table public.profiles enable row level security;
create policy "profiles_select" on public.profiles for select using (true);
create policy "profiles_update" on public.profiles for update using (auth.uid() = id);

-- ============================================================
-- PLACES
-- ============================================================

create table public.places (
  id                  uuid primary key default uuid_generate_v4(),
  name                text not null,
  category            text not null,
  space_type          space_type not null,
  status              place_status not null default 'pending',
  lat                 double precision not null,
  lng                 double precision not null,
  geo                 geometry(Point, 4326) generated always as
                        (ST_SetSRID(ST_MakePoint(lng, lat), 4326)) stored,
  address             text,
  operating_hours     jsonb,
  anchor_descriptor   bytea,
  anchor_image_hash   text,
  spatial_fingerprint bytea,
  global_embedding    vector(512),
  reference_count     int not null default 0,
  pending_count       int not null default 0,
  registered_by       uuid references public.profiles(id),
  external_source     text,
  external_id         text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);

create index places_geo_idx      on public.places using gist(geo);
create index places_status_idx   on public.places(status);
create index places_category_idx on public.places(category);

alter table public.places enable row level security;
create policy "places_select" on public.places for select using (true);
create policy "places_insert" on public.places for insert with check (auth.uid() is not null);

-- ============================================================
-- PLACE SUBMISSIONS  (consensus registration rounds)
-- ============================================================

create table public.place_submissions (
  id                   uuid primary key default uuid_generate_v4(),
  place_id             uuid not null references public.places(id) on delete cascade,
  submitted_by         uuid not null references public.profiles(id),
  round_number         int not null,
  liveness_passed      bool not null default false,
  vision_score         float,
  embedding_similarity float,
  inlier_count         int,
  depth_variance       float,
  sensor_match_score   float,
  final_score          float,
  gps_lat              double precision,
  gps_lng              double precision,
  wifi_fingerprint     jsonb,
  imu_snapshot         jsonb,
  certificate_hash     text,
  frame_count          int,
  status               text not null default 'pending',
  reject_reason        text,
  created_at           timestamptz not null default now()
);

alter table public.place_submissions enable row level security;
create policy "submissions_select" on public.place_submissions for select using (auth.uid() = submitted_by);
create policy "submissions_insert" on public.place_submissions for insert with check (auth.uid() = submitted_by);

-- ============================================================
-- FOLLOWS
-- ============================================================

create table public.follows (
  follower_id  uuid not null references public.profiles(id) on delete cascade,
  following_id uuid not null references public.profiles(id) on delete cascade,
  created_at   timestamptz not null default now(),
  primary key (follower_id, following_id),
  check (follower_id <> following_id)
);

alter table public.follows enable row level security;
create policy "follows_select" on public.follows for select using (true);
create policy "follows_all"    on public.follows for all    using (auth.uid() = follower_id);

-- ============================================================
-- FRIENDSHIPS  (bidirectional — both follow each other)
-- ============================================================

create table public.friendships (
  user_id    uuid not null references public.profiles(id) on delete cascade,
  friend_id  uuid not null references public.profiles(id) on delete cascade,
  status     text not null default 'pending',
  created_at timestamptz not null default now(),
  primary key (user_id, friend_id),
  check (user_id <> friend_id)
);

alter table public.friendships enable row level security;
create policy "friendships_select" on public.friendships for select
  using (auth.uid() = user_id or auth.uid() = friend_id);
create policy "friendships_all" on public.friendships for all using (auth.uid() = user_id);

-- ============================================================
-- STAMPS  (RLS references friendships — must come after it)
-- ============================================================

create table public.stamps (
  id               uuid primary key default uuid_generate_v4(),
  user_id          uuid not null references public.profiles(id) on delete cascade,
  place_id         uuid not null references public.places(id),
  tier             auth_tier not null,
  visibility       visibility not null default 'public',
  caption          text,
  photo_urls       text[],
  audio_url        text,
  music_track      jsonb,
  sensory_tags     text[],
  tagged_user_ids  uuid[],
  weather          text,
  season           text,
  time_of_day      text,
  local_time       timestamptz,
  certificate_hash text,
  vision_score     float,
  sensor_score     float,
  final_score      float,
  like_count       int not null default 0,
  comment_count    int not null default 0,
  save_count       int not null default 0,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

create index stamps_user_id_idx   on public.stamps(user_id);
create index stamps_place_id_idx  on public.stamps(place_id);
create index stamps_created_at_idx on public.stamps(created_at desc);
create index stamps_visibility_idx on public.stamps(visibility);
create index stamps_user_timeline_idx on public.stamps(user_id, created_at desc)
  where visibility != 'private';
create index stamps_place_public_idx  on public.stamps(place_id, created_at desc)
  where visibility = 'public';

alter table public.stamps enable row level security;
create policy "stamps_select_public" on public.stamps for select
  using (visibility = 'public' or auth.uid() = user_id);
create policy "stamps_select_friends" on public.stamps for select
  using (
    visibility = 'friends' and (
      auth.uid() = user_id or
      exists (
        select 1 from public.friendships
        where (user_id = auth.uid() and friend_id = stamps.user_id)
          and status = 'accepted'
      )
    )
  );
create policy "stamps_insert" on public.stamps for insert with check (auth.uid() = user_id);
create policy "stamps_update" on public.stamps for update using (auth.uid() = user_id);
create policy "stamps_delete" on public.stamps for delete using (auth.uid() = user_id);

-- ============================================================
-- STAMP LIKES
-- ============================================================

create table public.stamp_likes (
  stamp_id   uuid not null references public.stamps(id) on delete cascade,
  user_id    uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (stamp_id, user_id)
);

alter table public.stamp_likes enable row level security;
create policy "likes_select" on public.stamp_likes for select using (true);
create policy "likes_all"    on public.stamp_likes for all    using (auth.uid() = user_id);

create or replace function update_stamp_like_count()
returns trigger language plpgsql as $$
begin
  if TG_OP = 'INSERT' then
    update public.stamps set like_count = like_count + 1 where id = NEW.stamp_id;
  elsif TG_OP = 'DELETE' then
    update public.stamps set like_count = like_count - 1 where id = OLD.stamp_id;
  end if;
  return null;
end;
$$;
create trigger stamp_like_count_trigger
after insert or delete on public.stamp_likes
for each row execute function update_stamp_like_count();

-- ============================================================
-- STAMP COMMENTS
-- ============================================================

create table public.stamp_comments (
  id         uuid primary key default uuid_generate_v4(),
  stamp_id   uuid not null references public.stamps(id) on delete cascade,
  user_id    uuid not null references public.profiles(id) on delete cascade,
  parent_id  uuid references public.stamp_comments(id) on delete cascade,
  body       text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.stamp_comments enable row level security;
create policy "comments_select" on public.stamp_comments for select using (true);
create policy "comments_insert" on public.stamp_comments for insert with check (auth.uid() = user_id);
create policy "comments_update" on public.stamp_comments for update using (auth.uid() = user_id);
create policy "comments_delete" on public.stamp_comments for delete using (auth.uid() = user_id);

-- ============================================================
-- BADGES
-- ============================================================

create table public.badges (
  id              uuid primary key default uuid_generate_v4(),
  name            text not null,
  description     text,
  badge_type      badge_type not null,
  place_id        uuid references public.places(id),
  icon_url        text,
  rarity          text not null default 'common',
  is_limited      bool not null default false,
  available_from  timestamptz,
  available_until timestamptz,
  created_at      timestamptz not null default now()
);

alter table public.badges enable row level security;
create policy "badges_select" on public.badges for select using (true);

-- ============================================================
-- USER BADGES
-- ============================================================

create table public.user_badges (
  id            uuid primary key default uuid_generate_v4(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  badge_id      uuid not null references public.badges(id),
  stamp_id      uuid references public.stamps(id),
  place_id      uuid references public.places(id),
  earned_at     timestamptz not null default now(),
  is_backfilled bool not null default false,
  unique(user_id, badge_id)
);

create index user_badges_user_id_idx on public.user_badges(user_id, earned_at desc);

alter table public.user_badges enable row level security;
create policy "user_badges_select" on public.user_badges for select using (true);
create policy "user_badges_insert" on public.user_badges for insert with check (true);

create or replace function update_profile_badge_count()
returns trigger language plpgsql as $$
begin
  if TG_OP = 'INSERT' then
    update public.profiles set badge_count = badge_count + 1 where id = NEW.user_id;
  end if;
  return null;
end;
$$;
create trigger badge_count_trigger
after insert on public.user_badges
for each row execute function update_profile_badge_count();

-- ============================================================
-- NOTIFICATIONS
-- ============================================================

create table public.notifications (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  type       text not null,
  title      text not null,
  body       text,
  data       jsonb,
  is_read    bool not null default false,
  deep_link  text,
  created_at timestamptz not null default now()
);

create index notifications_user_id_idx on public.notifications(user_id, created_at desc);

alter table public.notifications enable row level security;
create policy "notifications_select" on public.notifications for select using (auth.uid() = user_id);
create policy "notifications_update" on public.notifications for update using (auth.uid() = user_id);

-- ============================================================
-- PLACE COVERAGE
-- ============================================================

create table public.place_coverage (
  place_id             uuid primary key references public.places(id) on delete cascade,
  total_submissions    int not null default 0,
  accepted_submissions int not null default 0,
  unique_submitters    int not null default 0,
  viewpoint_clusters   int not null default 0,
  has_daytime          bool not null default false,
  has_nighttime        bool not null default false,
  sensor_consistency   float,
  rejection_rate       float,
  needs_review         bool not null default false,
  last_updated         timestamptz not null default now()
);

alter table public.place_coverage enable row level security;
create policy "coverage_select" on public.place_coverage for select using (true);

-- ============================================================
-- STAMP SAVES
-- ============================================================

create table public.stamp_saves (
  stamp_id   uuid not null references public.stamps(id) on delete cascade,
  user_id    uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (stamp_id, user_id)
);

alter table public.stamp_saves enable row level security;
create policy "saves_select" on public.stamp_saves for select using (auth.uid() = user_id);
create policy "saves_all"    on public.stamp_saves for all    using (auth.uid() = user_id);

-- ============================================================
-- USER PRIVACY SETTINGS
-- ============================================================

create table public.user_privacy (
  user_id                  uuid primary key references public.profiles(id) on delete cascade,
  default_stamp_visibility visibility not null default 'public',
  location_sharing         bool not null default false,
  ghost_mode               bool not null default false,
  safe_zones               jsonb,
  created_at               timestamptz not null default now(),
  updated_at               timestamptz not null default now()
);

alter table public.user_privacy enable row level security;
create policy "privacy_all" on public.user_privacy for all using (auth.uid() = user_id);

-- ============================================================
-- FEED ITEMS
-- ============================================================

create table public.feed_items (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null,
  stamp_id   uuid not null references public.stamps(id) on delete cascade,
  author_id  uuid not null,
  score      float not null default 0,
  created_at timestamptz not null default now()
);

create index feed_items_user_id_idx on public.feed_items(user_id, score desc, created_at desc);

alter table public.feed_items enable row level security;
create policy "feed_select" on public.feed_items for select using (auth.uid() = user_id);

-- ============================================================
-- VIEWS
-- ============================================================

create or replace view public.v_places_with_coverage as
  select
    p.*,
    pc.total_submissions,
    pc.accepted_submissions,
    pc.unique_submitters,
    pc.has_daytime,
    pc.has_nighttime,
    pc.rejection_rate,
    pc.needs_review
  from public.places p
  left join public.place_coverage pc on p.id = pc.place_id;

create or replace view public.v_user_stamp_stats as
  select
    user_id,
    count(*)                                      as total_stamps,
    count(*) filter (where tier = 'tier1')        as tier1_count,
    count(*) filter (where tier = 'tier2')        as tier2_count,
    count(distinct place_id)                      as unique_places,
    count(distinct date_trunc('day', created_at)) as active_days
  from public.stamps
  group by user_id;

-- ============================================================
-- FUNCTIONS
-- ============================================================

create or replace function public.places_within_radius(
  user_lat double precision,
  user_lng double precision,
  radius_m double precision default 500
)
returns setof public.v_places_with_coverage
language sql stable as $$
  select *
  from public.v_places_with_coverage
  where ST_DWithin(
    geo::geography,
    ST_SetSRID(ST_MakePoint(user_lng, user_lat), 4326)::geography,
    radius_m
  )
  order by ST_Distance(
    geo::geography,
    ST_SetSRID(ST_MakePoint(user_lng, user_lat), 4326)::geography
  );
$$;

create or replace function public.check_and_confirm_place(p_place_id uuid)
returns void language plpgsql as $$
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

-- Auto-create profile row when a new user signs up
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
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

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();
