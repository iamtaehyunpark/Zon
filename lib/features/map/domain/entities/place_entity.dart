import '../../../../data/models/place_status.dart';
import '../../../../data/models/space_type.dart';

/// Domain entity for a Place — pure Dart, no Flutter or Supabase imports.
class PlaceEntity {
  const PlaceEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.spaceType,
    required this.status,
    required this.lat,
    required this.lng,
    this.address,
    this.referenceCount = 0,
  });

  final String id;
  final String name;
  final String category;
  final SpaceType spaceType;
  final PlaceStatus status;
  final double lat;
  final double lng;
  final String? address;
  final int referenceCount;
}
