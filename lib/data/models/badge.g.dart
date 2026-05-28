// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeImpl _$$BadgeImplFromJson(Map<String, dynamic> json) => _$BadgeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      badgeType: $enumDecode(_$BadgeTypeEnumMap, json['badge_type']),
      rarity: json['rarity'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      placeId: json['place_id'] as String?,
      isLimited: json['is_limited'] as bool? ?? false,
      availableFrom: json['available_from'] == null
          ? null
          : DateTime.parse(json['available_from'] as String),
      availableUntil: json['available_until'] == null
          ? null
          : DateTime.parse(json['available_until'] as String),
      earnedAt: json['earned_at'] == null
          ? null
          : DateTime.parse(json['earned_at'] as String),
      isEarned: json['is_earned'] as bool? ?? false,
      isBackfilled: json['is_backfilled'] as bool? ?? false,
    );

Map<String, dynamic> _$$BadgeImplToJson(_$BadgeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'badge_type': _$BadgeTypeEnumMap[instance.badgeType]!,
      'rarity': instance.rarity,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'place_id': instance.placeId,
      'is_limited': instance.isLimited,
      'available_from': instance.availableFrom?.toIso8601String(),
      'available_until': instance.availableUntil?.toIso8601String(),
      'earned_at': instance.earnedAt?.toIso8601String(),
      'is_earned': instance.isEarned,
      'is_backfilled': instance.isBackfilled,
    };

const _$BadgeTypeEnumMap = {
  BadgeType.placeSignature: 'place_signature',
  BadgeType.seasonal: 'seasonal',
  BadgeType.pioneer: 'pioneer',
  BadgeType.founder: 'founder',
  BadgeType.confirmer: 'confirmer',
  BadgeType.quest: 'quest',
  BadgeType.brand: 'brand',
};
