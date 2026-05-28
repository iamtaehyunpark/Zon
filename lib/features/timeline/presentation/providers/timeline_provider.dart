import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../feed/data/models/feed_item.dart';
import '../../../../data/datasources/remote/stamp_select.dart';

part 'timeline_provider.g.dart';

/// Loads the current user's stamps ordered by date, grouped by calendar day.
@riverpod
class TimelineNotifier extends _$TimelineNotifier {
  @override
  Future<Map<DateTime, List<FeedItem>>> build() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return {};

    final rows = await Supabase.instance.client
        .from('stamps')
        .select(kStampSelect)
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
