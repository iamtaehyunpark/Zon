import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../feed/data/models/feed_item.dart';

part 'timeline_provider.g.dart';

/// Loads the current user's stamps ordered by date, grouped by calendar day.
@riverpod
class TimelineNotifier extends _$TimelineNotifier {
  static const _select =
      'id, tier, caption, photo_urls, sensory_tags, like_count, comment_count, final_score, created_at, '
      'places!place_id(id, name, category), '
      'profiles!user_id(id, username, display_name, avatar_url)';

  @override
  Future<Map<DateTime, List<FeedItem>>> build() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return {};

    final rows = await Supabase.instance.client
        .from('stamps')
        .select(_select)
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(200) as List<dynamic>;

    final items = rows
        .map((r) => FeedItem.fromJson(r as Map<String, dynamic>))
        .toList();

    // Group by calendar day (local time, time-zeroed)
    final Map<DateTime, List<FeedItem>> grouped = {};
    for (final item in items) {
      final day = DateTime(
        item.createdAt.toLocal().year,
        item.createdAt.toLocal().month,
        item.createdAt.toLocal().day,
      );
      grouped.putIfAbsent(day, () => []).add(item);
    }
    return grouped;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(build);
  }
}
