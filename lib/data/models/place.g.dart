// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceImpl _$$PlaceImplFromJson(Map<String, dynamic> json) => _$PlaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      spaceType: $enumDecode(_$SpaceTypeEnumMap, json['space_type']),
      status: $enumDecode(_$PlaceStatusEnumMap, json['status']),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String?,
      pendingCount: (json['pending_count'] as num?)?.toInt(),
      referenceCount: (json['reference_count'] as num?)?.toInt(),
      hasBadge: json['has_badge'] as bool?,
    );

Map<String, dynamic> _$$PlaceImplToJson(_$PlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'space_type': _$SpaceTypeEnumMap[instance.spaceType]!,
      'status': _$PlaceStatusEnumMap[instance.status]!,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'pending_count': instance.pendingCount,
      'reference_count': instance.referenceCount,
      'has_badge': instance.hasBadge,
    };

const _$SpaceTypeEnumMap = {
  SpaceType.outdoorArtificial: 'outdoor_artificial',
  SpaceType.outdoorNatural: 'outdoor_natural',
  SpaceType.indoorArtificial: 'indoor_artificial',
  SpaceType.indoorNatural: 'indoor_natural',
};

const _$PlaceStatusEnumMap = {
  PlaceStatus.pending: 'pending',
  PlaceStatus.confirmed: 'confirmed',
  PlaceStatus.external: 'external',
};
