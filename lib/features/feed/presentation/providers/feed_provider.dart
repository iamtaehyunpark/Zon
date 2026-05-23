import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/stamp_entity.dart';

part 'feed_provider.g.dart';

/// Loads and manages the social feed of Stamps.
/// Uses AsyncNotifierProvider because feed data is fetched from Supabase.
@riverpod
class FeedNotifier extends _$FeedNotifier {
  @override
  Future<List<StampEntity>> build() async {
    // TODO(M2): implement feed loading from Supabase via FeedRepository
    return [];
  }
}
