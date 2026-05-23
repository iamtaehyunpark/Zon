// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stamp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StampImpl _$$StampImplFromJson(Map<String, dynamic> json) => _$StampImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      placeId: json['placeId'] as String,
      tier: $enumDecode(_$AuthTierEnumMap, json['tier']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      visibility: $enumDecode(_$StampVisibilityEnumMap, json['visibility']),
      caption: json['caption'] as String?,
      photoUrls: (json['photoUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      audioUrl: json['audioUrl'] as String?,
      weather: json['weather'] as String?,
      season: json['season'] as String?,
      timeOfDay: json['timeOfDay'] as String?,
      visionScore: (json['visionScore'] as num?)?.toDouble(),
      finalScore: (json['finalScore'] as num?)?.toDouble(),
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
    );

Map<String, dynamic> _$$StampImplToJson(_$StampImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'placeId': instance.placeId,
      'tier': _$AuthTierEnumMap[instance.tier]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'visibility': _$StampVisibilityEnumMap[instance.visibility]!,
      'caption': instance.caption,
      'photoUrls': instance.photoUrls,
      'audioUrl': instance.audioUrl,
      'weather': instance.weather,
      'season': instance.season,
      'timeOfDay': instance.timeOfDay,
      'visionScore': instance.visionScore,
      'finalScore': instance.finalScore,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'isLiked': instance.isLiked,
      'isSaved': instance.isSaved,
    };

const _$AuthTierEnumMap = {
  AuthTier.tier1: 'tier1',
  AuthTier.tier2: 'tier2',
  AuthTier.tier3: 'tier3',
};

const _$StampVisibilityEnumMap = {
  StampVisibility.public: 'public',
  StampVisibility.friends: 'friends',
  StampVisibility.private: 'private',
};
