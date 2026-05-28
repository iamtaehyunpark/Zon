// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stamp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StampImpl _$$StampImplFromJson(Map<String, dynamic> json) => _$StampImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      placeId: json['place_id'] as String,
      tier: $enumDecode(_$AuthTierEnumMap, json['tier']),
      createdAt: DateTime.parse(json['created_at'] as String),
      visibility: $enumDecode(_$StampVisibilityEnumMap, json['visibility']),
      caption: json['caption'] as String?,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      audioUrl: json['audio_url'] as String?,
      weather: json['weather'] as String?,
      season: json['season'] as String?,
      timeOfDay: json['time_of_day'] as String?,
      visionScore: (json['vision_score'] as num?)?.toDouble(),
      sensorScore: (json['sensor_score'] as num?)?.toDouble(),
      finalScore: (json['final_score'] as num?)?.toDouble(),
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      isSaved: json['is_saved'] as bool? ?? false,
    );

Map<String, dynamic> _$$StampImplToJson(_$StampImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'place_id': instance.placeId,
      'tier': _$AuthTierEnumMap[instance.tier]!,
      'created_at': instance.createdAt.toIso8601String(),
      'visibility': _$StampVisibilityEnumMap[instance.visibility]!,
      'caption': instance.caption,
      'photo_urls': instance.photoUrls,
      'audio_url': instance.audioUrl,
      'weather': instance.weather,
      'season': instance.season,
      'time_of_day': instance.timeOfDay,
      'vision_score': instance.visionScore,
      'sensor_score': instance.sensorScore,
      'final_score': instance.finalScore,
      'like_count': instance.likeCount,
      'comment_count': instance.commentCount,
      'is_liked': instance.isLiked,
      'is_saved': instance.isSaved,
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
