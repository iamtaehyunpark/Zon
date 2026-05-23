import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/place_entity.dart';

part 'map_provider.g.dart';

/// Manages nearby Places shown on the map and the currently selected Place.
@riverpod
class MapNotifier extends _$MapNotifier {
  @override
  Future<List<PlaceEntity>> build() async {
    // TODO(M2): load places via places_within_radius Postgres function
    return [];
  }
}
