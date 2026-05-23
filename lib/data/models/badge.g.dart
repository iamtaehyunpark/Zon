// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeImpl _$$BadgeImplFromJson(Map<String, dynamic> json) => _$BadgeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      badgeType: $enumDecode(_$BadgeTypeEnumMap, json['badgeType']),
      rarity: json['rarity'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      placeId: json['placeId'] as String?,
      isLimited: json['isLimited'] as bool? ?? false,
      availableFrom: json['availableFrom'] == null
          ? null
          : DateTime.parse(json['availableFrom'] as String),
      availableUntil: json['availableUntil'] == null
          ? null
          : DateTime.parse(json['availableUntil'] as String),
      earnedAt: json['earnedAt'] == null
          ? null
          : DateTime.parse(json['earnedAt'] as String),
      isEarned: json['isEarned'] as bool? ?? false,
      isBackfilled: json['isBackfilled'] as bool? ?? false,
    );

Map<String, dynamic> _$$BadgeImplToJson(_$BadgeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'badgeType': _$BadgeTypeEnumMap[instance.badgeType]!,
      'rarity': instance.rarity,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'placeId': instance.placeId,
      'isLimited': instance.isLimited,
      'availableFrom': instance.availableFrom?.toIso8601String(),
      'availableUntil': instance.availableUntil?.toIso8601String(),
      'earnedAt': instance.earnedAt?.toIso8601String(),
      'isEarned': instance.isEarned,
      'isBackfilled': instance.isBackfilled,
    };

const _$BadgeTypeEnumMap = {
  BadgeType.placeSignature: 'placeSignature',
  BadgeType.seasonal: 'seasonal',
  BadgeType.pioneer: 'pioneer',
  BadgeType.founder: 'founder',
  BadgeType.confirmer: 'confirmer',
  BadgeType.quest: 'quest',
  BadgeType.brand: 'brand',
};
