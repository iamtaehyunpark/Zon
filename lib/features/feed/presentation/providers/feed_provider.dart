import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/feed_item.dart';

part 'feed_provider.g.dart';

/// Loads and manages the paginated public feed of Stamps.
@riverpod
class FeedNotifier extends _$FeedNotifier {
  static const _pageSize = 20;
  static const _select =
      'id, tier, caption, photo_urls, sensory_tags, like_count, comment_count, final_score, created_at, '
      'places!place_id(id, name, category), '
      'profiles!user_id(id, username, display_name, avatar_url)';

  @override
  Future<List<FeedItem>> build() => _fetch();

  Future<List<FeedItem>> _fetch({String? beforeCursor}) async {
    // Build filter chain before applying order+limit (lt is a filter method)
    var q = Supabase.instance.client
        .from('stamps')
        .select(_select)
        .eq('visibility', 'public');

    if (beforeCursor != null) {
      q = q.lt('created_at', beforeCursor);
    }

    final rows = await q
        .order('created_at', ascending: false)
        .limit(_pageSize) as List<dynamic>;
    return rows
        .map((r) => FeedItem.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  /// Pull-to-refresh: reload from top.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  /// Append next page to existing list.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isEmpty) return;
    final cursor = current.last.createdAt.toIso8601String();
    final next = await _fetch(beforeCursor: cursor);
    if (next.isNotEmpty) {
      state = AsyncValue.data([...current, ...next]);
    }
  }
}
