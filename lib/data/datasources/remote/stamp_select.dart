/// Shared Supabase SELECT string for stamp queries with joined place and profile.
const kStampSelect =
    'id, tier, caption, photo_urls, sensory_tags, like_count, comment_count, '
    'final_score, created_at, '
    'places!place_id(id, name, category), '
    'profiles!user_id(id, username, display_name, avatar_url)';
