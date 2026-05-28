import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/feed_item.dart';
import '../../../../data/datasources/remote/stamp_select.dart';

part 'feed_provider.g.dart';

/// Tracks whether more pages exist. Companion to [FeedNotifier].
final feedHasMoreProvider = StateProvider<bool>((ref) => true);

/// Loads and manages the paginated public feed of Stamps.
@riverpod
class FeedNotifier extends _$FeedNotifier {
  static const _pageSize = 20;

  bool _isLoadingMore = false;

  @override
  Future<List<FeedItem>> build() {
    ref.read(feedHasMoreProvider.notifier).state = true;
    return _fetch();
  }

  Future<List<FeedItem>> _fetch({String? beforeCursor}) async {
    var q = Supabase.instance.client
        .from('stamps')
        .select(kStampSelect)
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
    ref.read(feedHasMoreProvider.notifier).state = true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  /// Append next page to existing list.
  Future<void> loadMore() async {
    if (_isLoadingMore) return;
    if (!ref.read(feedHasMoreProvider)) return;
    final current = state.valueOrNull;
    if (current == null || current.isEmpty) return;

    _isLoadingMore = true;
    try {
      final cursor = current.last.createdAt.toIso8601String();
      final next = await _fetch(beforeCursor: cursor);

      if (next.length < _pageSize) {
        ref.read(feedHasMoreProvider.notifier).state = false;
      }
      if (next.isNotEmpty) {
        state = AsyncValue.data([...current, ...next]);
      }
    } finally {
      _isLoadingMore = false;
    }
  }
}
