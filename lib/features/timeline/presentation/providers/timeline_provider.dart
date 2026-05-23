import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../feed/domain/entities/stamp_entity.dart';

part 'timeline_provider.g.dart';

/// Loads the user's personal Stamp history grouped by date for the calendar view.
@riverpod
class TimelineNotifier extends _$TimelineNotifier {
  @override
  Future<Map<DateTime, List<StampEntity>>> build() async {
    // TODO(M2): load user's stamps ordered by date from Supabase
    return {};
  }
}
