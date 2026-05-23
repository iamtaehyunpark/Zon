// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      countryCount: (json['countryCount'] as num?)?.toInt() ?? 0,
      placeCount: (json['placeCount'] as num?)?.toInt() ?? 0,
      badgeCount: (json['badgeCount'] as num?)?.toInt() ?? 0,
      followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'countryCount': instance.countryCount,
      'placeCount': instance.placeCount,
      'badgeCount': instance.badgeCount,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
