// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceImpl _$$PlaceImplFromJson(Map<String, dynamic> json) => _$PlaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      spaceType: $enumDecode(_$SpaceTypeEnumMap, json['spaceType']),
      status: $enumDecode(_$PlaceStatusEnumMap, json['status']),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String?,
      pendingCount: (json['pendingCount'] as num?)?.toInt(),
      referenceCount: (json['referenceCount'] as num?)?.toInt(),
      hasBadge: json['hasBadge'] as bool?,
    );

Map<String, dynamic> _$$PlaceImplToJson(_$PlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'spaceType': _$SpaceTypeEnumMap[instance.spaceType]!,
      'status': _$PlaceStatusEnumMap[instance.status]!,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'pendingCount': instance.pendingCount,
      'referenceCount': instance.referenceCount,
      'hasBadge': instance.hasBadge,
    };

const _$SpaceTypeEnumMap = {
  SpaceType.outdoorArtificial: 'outdoorArtificial',
  SpaceType.outdoorNatural: 'outdoorNatural',
  SpaceType.indoorArtificial: 'indoorArtificial',
  SpaceType.indoorNatural: 'indoorNatural',
};

const _$PlaceStatusEnumMap = {
  PlaceStatus.pending: 'pending',
  PlaceStatus.confirmed: 'confirmed',
  PlaceStatus.external: 'external',
};
