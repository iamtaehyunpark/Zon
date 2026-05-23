-- ============================================================
-- ZON — Supabase Database Schema
-- Source of truth for all table definitions and RLS policies.
-- Run migrations in order via Supabase dashboard or CLI.
-- ============================================================

-- Enable required extensions
create extension if not exists "uuid-ossp";
create extension if not exists "postgis";   -- for geo queries

-- ============================================================
-- ENUMS
-- ============================================================

create type auth_tier as enum ('tier1', 'tier2', 'tier3');

create type place_status as enum (
  'pending',      -- collecting consensus submissions (Stage 1-2)
  'confirmed',    -- n-round verified, live landmark (Stage 3)
  'external'      -- pre-loaded from Google Places / public DB (Stage 0)
);

create type space_type as enum (
  'outdoor_artificial',   -- Route A: buildings, landmarks
  'outdoor_natural',      -- Route B: mountains, beaches
  'indoor_artificial',    -- Route C: restaurants, cafes
  'indoor_natural'        -- Route C': caves, greenhouses
);

create type badge_type as enum (
  'place_signature',    -- one per place
  'seasonal',           -- time-limited
  'pioneer',            -- first registrant
  'founder',            -- early contributor
  'confirmer',          -- coverage completer
  'quest',              -- quest completion
  'brand'               -- brand campaign
);

create type visibility as enum ('public', 'friends', 'private');

-- ============================================================
-- USERS (extends Supabase auth.users)
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

-- RLS
alter table public.profiles enable row level security;
create policy "Public profiles are viewable by everyone"
  on public.profiles for select using (true);
create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);

-- ============================================================
-- PLACES
-- ============================================================

create table public.places (
  id                    uuid primary key default uuid_generate_v4(),
  name                  text not null,
  category              text not null,
  space_type            space_type not null,
  status                place_status not null default 'pending',
  lat                   double precision not null,
  lng                   double precision not null,
  geo                   geometry(Point, 4326) generated always as
                          (ST_SetSRID(ST_MakePoint(lng, lat), 4326)) stored,
  address               text,
  operating_hours       jsonb,                -- { mon: "09:00-21:00", ... }
  anchor_descriptor     bytea,               -- SuperPoint descriptor bytes
  anchor_image_hash     text,               -- SHA-256 of anchor crop
  spatial_fingerprint   bytea,              -- point cloud / depth signature
  global_embedding      vector(512),        -- MixVPR embedding (pgvector)
  reference_count       int not null default 0,
  pending_count         int not null default 0,
  registered_by         uuid references public.profiles(id),
  external_source       text,               -- 'google_places', 'wikipedia', etc.
  external_id           text,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

create index places_geo_idx on public.places using gist(geo);
create index places_status_idx on public.places(status);
create index places_category_idx on public.places(category);

-- RLS
alter table public.places enable row level security;
create policy "Places are viewable by everyone"
  on public.places for select using (true);
create policy "Authenticated users can insert places"
  on public.places for insert with check (auth.uid() is not null);

-- ============================================================
-- PLACE REFERENCE SUBMISSIONS (Consensus Registration)
-- Each submission = one round of the n-round consensus
-- ============================================================

create table public.place_submissions (
  id                    uuid primary key default uuid_generate_v4(),
  place_id              uuid not null references public.places(id) on delete cascade,
  submitted_by          uuid not null references public.profiles(id),
  round_number          int not null,                -- 1 = pioneer, 2+ = founder
  liveness_passed       bool not null default false,
  vision_score          float,                       -- 0.0 – 1.0
  embedding_similarity  float,                       -- vs existing references
  inlier_count          int,                         -- keypoint inliers
  depth_variance        float,
  sensor_match_score    float,
  final_score           float,
  gps_lat               double precision,
  gps_lng               double precision,
  wifi_fingerprint      jsonb,                       -- { bssid: rssi, ... }
  imu_snapshot          jsonb,
  certificate_hash      text,                        -- on-device signed hash
  frame_count           int,
  status                text not null default 'pending',  -- 'accepted', 'rejected'
  reject_reason         text,
  created_at            timestamptz not null default now()
);

alter table public.place_submissions enable row level security;
create policy "Users can view own submissions"
  on public.place_submissions for select using (auth.uid() = submitted_by);
create policy "Authenticated users can insert submissions"
  on public.place_submissions for insert with check (auth.uid() = submitted_by);

-- ============================================================
-- STAMPS
-- ============================================================

create table public.stamps (
  id                uuid primary key default uuid_generate_v4(),
  user_id           uuid not null references public.profiles(id) on delete cascade,
  place_id          uuid not null references public.places(id),
  tier              auth_tier not null,
  visibility        visibility not null default 'public',

  -- Content
  caption           text,
  photo_urls        text[],           -- Supabase Storage URLs
  audio_url         text,             -- Supabase Storage URL
  music_track       jsonb,            -- { title, artist, album_art_url, spotify_id }
  sensory_tags      text[],           -- ['coffee_scent', 'lively', 'sunny']
  tagged_user_ids   uuid[],           -- friend tags (Phase 2)

  -- Temporal context (auto-captured)
  weather           text,
  season            text,
  time_of_day       text,             -- 'morning', 'afternoon', 'evening', 'night'
  local_time        timestamptz,

  -- Verification data
  certificate_hash  text,             -- on-device signed verification hash
  vision_score      float,
  sensor_score      float,
  final_score       float,

  -- Engagement counters (denormalized for read performance)
  like_count        int not null default 0,
  comment_count     int not null default 0,
  save_count        int not null default 0,

  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create index stamps_user_id_idx on public.stamps(user_id);
create index stamps_place_id_idx on public.stamps(place_id);
create index stamps_created_at_idx on public.stamps(created_at desc);
create index stamps_visibility_idx on public.stamps(visibility);

alter table public.stamps enable row level security;
create policy "Public stamps are viewable by everyone"
  on public.stamps for select
  using (visibility = 'public' or auth.uid() = user_id);
create policy "Friends stamps visible to friends"
  on public.stamps for select
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
create policy "Users can insert own stamps"
  on public.stamps for insert with check (auth.uid() = user_id);
create policy "Users can update own stamps"
  on public.stamps for update using (auth.uid() = user_id);
create policy "Users can delete own stamps"
  on public.stamps for delete using (auth.uid() = user_id);

-- ============================================================
-- STAMP LIKES
-- ============================================================

create table public.stamp_likes (
  stamp_id    uuid not null references public.stamps(id) on delete cascade,
  user_id     uuid not null references public.profiles(id) on delete cascade,
  created_at  timestamptz not null default now(),
  primary key (stamp_id, user_id)
);

alter table public.stamp_likes enable row level security;
create policy "Likes are viewable by everyone"
  on public.stamp_likes for select using (true);
create policy "Users can like/unlike"
  on public.stamp_likes for all using (auth.uid() = user_id);

-- Trigger: update stamp like_count
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
  id          uuid primary key default uuid_generate_v4(),
  stamp_id    uuid not null references public.stamps(id) on delete cascade,
  user_id     uuid not null references public.profiles(id) on delete cascade,
  parent_id   uuid references public.stamp_comments(id) on delete cascade,
  body        text not null,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

alter table public.stamp_comments enable row level security;
create policy "Comments viewable based on stamp visibility"
  on public.stamp_comments for select using (true);
create policy "Authenticated users can comment"
  on public.stamp_comments for insert with check (auth.uid() = user_id);
create policy "Users can update own comments"
  on public.stamp_comments for update using (auth.uid() = user_id);
create policy "Users can delete own comments"
  on public.stamp_comments for delete using (auth.uid() = user_id);

-- ============================================================
-- BADGES
-- ============================================================

create table public.badges (
  id              uuid primary key default uuid_generate_v4(),
  name            text not null,
  description     text,
  badge_type      badge_type not null,
  place_id        uuid references public.places(id),   -- null for non-place badges
  icon_url        text,
  rarity          text not null default 'common',      -- 'common', 'rare', 'legendary'
  is_limited      bool not null default false,
  available_from  timestamptz,                         -- seasonal window start
  available_until timestamptz,                         -- seasonal window end
  created_at      timestamptz not null default now()
);

alter table public.badges enable row level security;
create policy "Badges are viewable by everyone"
  on public.badges for select using (true);

-- ============================================================
-- USER BADGES (earned)
-- ============================================================

create table public.user_badges (
  id           uuid primary key default uuid_generate_v4(),
  user_id      uuid not null references public.profiles(id) on delete cascade,
  badge_id     uuid not null references public.badges(id),
  stamp_id     uuid references public.stamps(id),      -- the stamp that earned it
  place_id     uuid references public.places(id),
  earned_at    timestamptz not null default now(),
  is_backfilled bool not null default false,            -- Pioneer/Founder retroactive
  unique(user_id, badge_id)
);

alter table public.user_badges enable row level security;
create policy "User badges are viewable by everyone"
  on public.user_badges for select using (true);
create policy "System inserts badges (via Edge Function)"
  on public.user_badges for insert with check (true);  -- restricted to service_role

-- Trigger: update profile badge_count
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
-- FOLLOWS / FRIENDSHIPS
-- ============================================================

create table public.follows (
  follower_id   uuid not null references public.profiles(id) on delete cascade,
  following_id  uuid not null references public.profiles(id) on delete cascade,
  created_at    timestamptz not null default now(),
  primary key (follower_id, following_id),
  check (follower_id <> following_id)
);

alter table public.follows enable row level security;
create policy "Follows are viewable by everyone"
  on public.follows for select using (true);
create policy "Users can follow/unfollow"
  on public.follows for all using (auth.uid() = follower_id);

-- Bidirectional friendship (both follow each other = friends)
create table public.friendships (
  user_id     uuid not null references public.profiles(id) on delete cascade,
  friend_id   uuid not null references public.profiles(id) on delete cascade,
  status      text not null default 'pending',  -- 'pending', 'accepted'
  created_at  timestamptz not null default now(),
  primary key (user_id, friend_id),
  check (user_id <> friend_id)
);

alter table public.friendships enable row level security;
create policy "Users can view their friendships"
  on public.friendships for select
  using (auth.uid() = user_id or auth.uid() = friend_id);
create policy "Users can manage their friendships"
  on public.friendships for all using (auth.uid() = user_id);

-- ============================================================
-- NOTIFICATIONS
-- ============================================================

create table public.notifications (
  id            uuid primary key default uuid_generate_v4(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  type          text not null,
  -- types: 'badge_earned', 'badge_backfilled', 'place_confirmed',
  --        'stamp_liked', 'stamp_commented', 'joint_memory',
  --        'quest_complete', 'coverage_update', 'friend_request'
  title         text not null,
  body          text,
  data          jsonb,              -- type-specific payload
  is_read       bool not null default false,
  deep_link     text,               -- go_router path
  created_at    timestamptz not null default now()
);

create index notifications_user_id_idx on public.notifications(user_id, created_at desc);

alter table public.notifications enable row level security;
create policy "Users see own notifications"
  on public.notifications for select using (auth.uid() = user_id);
create policy "Users can mark own notifications read"
  on public.notifications for update using (auth.uid() = user_id);

-- ============================================================
-- PLACE COVERAGE (materialized per-place consensus state)
-- ============================================================

create table public.place_coverage (
  place_id              uuid primary key references public.places(id) on delete cascade,
  total_submissions     int not null default 0,
  accepted_submissions  int not null default 0,
  unique_submitters     int not null default 0,
  viewpoint_clusters    int not null default 0,    -- distinct angle groups
  has_daytime           bool not null default false,
  has_nighttime         bool not null default false,
  sensor_consistency    float,                     -- avg GPS/WiFi agreement
  rejection_rate        float,                     -- rejected / total
  needs_review          bool not null default false,  -- rejection_rate > 0.5
  last_updated          timestamptz not null default now()
);

alter table public.place_coverage enable row level security;
create policy "Coverage is viewable by everyone"
  on public.place_coverage for select using (true);

-- ============================================================
-- STAMP SAVES (bookmarks)
-- ============================================================

create table public.stamp_saves (
  stamp_id    uuid not null references public.stamps(id) on delete cascade,
  user_id     uuid not null references public.profiles(id) on delete cascade,
  created_at  timestamptz not null default now(),
  primary key (stamp_id, user_id)
);

alter table public.stamp_saves enable row level security;
create policy "Users can view own saves"
  on public.stamp_saves for select using (auth.uid() = user_id);
create policy "Users can save/unsave"
  on public.stamp_saves for all using (auth.uid() = user_id);

-- ============================================================
-- USER PRIVACY SETTINGS
-- ============================================================

create table public.user_privacy (
  user_id                 uuid primary key references public.profiles(id) on delete cascade,
  default_stamp_visibility visibility not null default 'public',
  location_sharing        bool not null default false,  -- real-time location (Phase 3)
  ghost_mode              bool not null default false,
  safe_zones              jsonb,  -- [{ name, lat, lng, radius_m }]
  created_at              timestamptz not null default now(),
  updated_at              timestamptz not null default now()
);

alter table public.user_privacy enable row level security;
create policy "Users can view and update own privacy settings"
  on public.user_privacy for all using (auth.uid() = user_id);

-- ============================================================
-- FEED (denormalized for performance — updated by triggers)
-- ============================================================

create table public.feed_items (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid not null,    -- the feed owner (recipient)
  stamp_id    uuid not null references public.stamps(id) on delete cascade,
  author_id   uuid not null,    -- the stamp creator
  score       float not null default 0,   -- ranking score
  created_at  timestamptz not null default now()
);

create index feed_items_user_id_idx on public.feed_items(user_id, score desc, created_at desc);

alter table public.feed_items enable row level security;
create policy "Users see own feed"
  on public.feed_items for select using (auth.uid() = user_id);

-- ============================================================
-- USEFUL VIEWS
-- ============================================================

-- Nearby places (used by geofencing + map)
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

-- User stamp summary (for profile stats)
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

-- Find places within radius (meters)
create or replace function public.places_within_radius(
  user_lat  double precision,
  user_lng  double precision,
  radius_m  double precision default 500
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

-- Confirm place when coverage requirements are met
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
    -- Backfill Pioneer / Founder / Confirmer badges via Edge Function trigger
  end if;
end;
$$;

-- ============================================================
-- INDEXES for common queries
-- ============================================================

create index stamps_user_timeline_idx
  on public.stamps(user_id, created_at desc)
  where visibility != 'private';

create index stamps_place_public_idx
  on public.stamps(place_id, created_at desc)
  where visibility = 'public';

create index user_badges_user_id_idx
  on public.user_badges(user_id, earned_at desc);
