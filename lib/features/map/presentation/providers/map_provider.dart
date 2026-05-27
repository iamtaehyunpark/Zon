import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/place_entity.dart';
import '../../../../data/models/place_status.dart';
import '../../../../data/models/space_type.dart';

part 'map_provider.g.dart';

/// Holds the user's current GPS fix — updated once on load.
@riverpod
Future<Position?> userPosition(Ref ref) async {
  try {
    bool svc = await Geolocator.isLocationServiceEnabled();
    if (!svc) return null;

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(const Duration(seconds: 8));
  } catch (_) {
    return null;
  }
}

/// Manages nearby Places shown on the map and the currently selected Place.
@riverpod
class MapNotifier extends _$MapNotifier {
  double _lat = 37.5665;   // Seoul default
  double _lng = 126.9780;
  double _radiusM = 500;

  @override
  Future<List<PlaceEntity>> build() async {
    final pos = await ref.watch(userPositionProvider.future);
    if (pos != null) {
      _lat = pos.latitude;
      _lng = pos.longitude;
    }
    return _fetchPlaces();
  }

  Future<List<PlaceEntity>> _fetchPlaces() async {
    final rows = await Supabase.instance.client.rpc(
      'places_within_radius',
      params: {
        'user_lat': _lat,
        'user_lng': _lng,
        'radius_m': _radiusM,
      },
    ) as List<dynamic>;

    return rows.map((r) {
      final m = r as Map<String, dynamic>;
      return PlaceEntity(
        id:             m['id'] as String,
        name:           m['name'] as String,
        category:       m['category'] as String,
        spaceType:      _spaceType(m['space_type'] as String? ?? ''),
        status:         _placeStatus(m['status'] as String? ?? ''),
        lat:            (m['lat'] as num).toDouble(),
        lng:            (m['lng'] as num).toDouble(),
        address:        m['address'] as String?,
        referenceCount: (m['reference_count'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }

  void updateRadius(double radiusM) {
    _radiusM = radiusM;
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  static SpaceType _spaceType(String s) => switch (s) {
    'outdoor_artificial' => SpaceType.outdoorArtificial,
    'outdoor_natural'    => SpaceType.outdoorNatural,
    'indoor_artificial'  => SpaceType.indoorArtificial,
    'indoor_natural'     => SpaceType.indoorNatural,
    _                    => SpaceType.outdoorArtificial,
  };

  static PlaceStatus _placeStatus(String s) => switch (s) {
    'confirmed' => PlaceStatus.confirmed,
    'external'  => PlaceStatus.external,
    _           => PlaceStatus.pending,
  };

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchPlaces);
  }
}
