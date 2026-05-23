// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stamp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Stamp _$StampFromJson(Map<String, dynamic> json) {
  return _Stamp.fromJson(json);
}

/// @nodoc
mixin _$Stamp {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get placeId => throw _privateConstructorUsedError;
  AuthTier get tier => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  StampVisibility get visibility => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  List<String> get photoUrls => throw _privateConstructorUsedError;
  String? get audioUrl => throw _privateConstructorUsedError;
  String? get weather => throw _privateConstructorUsedError;
  String? get season => throw _privateConstructorUsedError;
  String? get timeOfDay => throw _privateConstructorUsedError;
  double? get visionScore => throw _privateConstructorUsedError;
  double? get finalScore => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;
  bool get isSaved => throw _privateConstructorUsedError;

  /// Serializes this Stamp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Stamp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StampCopyWith<Stamp> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StampCopyWith<$Res> {
  factory $StampCopyWith(Stamp value, $Res Function(Stamp) then) =
      _$StampCopyWithImpl<$Res, Stamp>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String placeId,
      AuthTier tier,
      DateTime createdAt,
      StampVisibility visibility,
      String? caption,
      List<String> photoUrls,
      String? audioUrl,
      String? weather,
      String? season,
      String? timeOfDay,
      double? visionScore,
      double? finalScore,
      int likeCount,
      int commentCount,
      bool isLiked,
      bool isSaved});
}

/// @nodoc
class _$StampCopyWithImpl<$Res, $Val extends Stamp>
    implements $StampCopyWith<$Res> {
  _$StampCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Stamp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? placeId = null,
    Object? tier = null,
    Object? createdAt = null,
    Object? visibility = null,
    Object? caption = freezed,
    Object? photoUrls = null,
    Object? audioUrl = freezed,
    Object? weather = freezed,
    Object? season = freezed,
    Object? timeOfDay = freezed,
    Object? visionScore = freezed,
    Object? finalScore = freezed,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? isLiked = null,
    Object? isSaved = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as AuthTier,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as StampVisibility,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: null == photoUrls
          ? _value.photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      audioUrl: freezed == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      weather: freezed == weather
          ? _value.weather
          : weather // ignore: cast_nullable_to_non_nullable
              as String?,
      season: freezed == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String?,
      timeOfDay: freezed == timeOfDay
          ? _value.timeOfDay
          : timeOfDay // ignore: cast_nullable_to_non_nullable
              as String?,
      visionScore: freezed == visionScore
          ? _value.visionScore
          : visionScore // ignore: cast_nullable_to_non_nullable
              as double?,
      finalScore: freezed == finalScore
          ? _value.finalScore
          : finalScore // ignore: cast_nullable_to_non_nullable
              as double?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaved: null == isSaved
          ? _value.isSaved
          : isSaved // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StampImplCopyWith<$Res> implements $StampCopyWith<$Res> {
  factory _$$StampImplCopyWith(
          _$StampImpl value, $Res Function(_$StampImpl) then) =
      __$$StampImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String placeId,
      AuthTier tier,
      DateTime createdAt,
      StampVisibility visibility,
      String? caption,
      List<String> photoUrls,
      String? audioUrl,
      String? weather,
      String? season,
      String? timeOfDay,
      double? visionScore,
      double? finalScore,
      int likeCount,
      int commentCount,
      bool isLiked,
      bool isSaved});
}

/// @nodoc
class __$$StampImplCopyWithImpl<$Res>
    extends _$StampCopyWithImpl<$Res, _$StampImpl>
    implements _$$StampImplCopyWith<$Res> {
  __$$StampImplCopyWithImpl(
      _$StampImpl _value, $Res Function(_$StampImpl) _then)
      : super(_value, _then);

  /// Create a copy of Stamp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? placeId = null,
    Object? tier = null,
    Object? createdAt = null,
    Object? visibility = null,
    Object? caption = freezed,
    Object? photoUrls = null,
    Object? audioUrl = freezed,
    Object? weather = freezed,
    Object? season = freezed,
    Object? timeOfDay = freezed,
    Object? visionScore = freezed,
    Object? finalScore = freezed,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? isLiked = null,
    Object? isSaved = null,
  }) {
    return _then(_$StampImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as AuthTier,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as StampVisibility,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: null == photoUrls
          ? _value._photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      audioUrl: freezed == audioUrl
          ? _value.audioUrl
          : audioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      weather: freezed == weather
          ? _value.weather
          : weather // ignore: cast_nullable_to_non_nullable
              as String?,
      season: freezed == season
          ? _value.season
          : season // ignore: cast_nullable_to_non_nullable
              as String?,
      timeOfDay: freezed == timeOfDay
          ? _value.timeOfDay
          : timeOfDay // ignore: cast_nullable_to_non_nullable
              as String?,
      visionScore: freezed == visionScore
          ? _value.visionScore
          : visionScore // ignore: cast_nullable_to_non_nullable
              as double?,
      finalScore: freezed == finalScore
          ? _value.finalScore
          : finalScore // ignore: cast_nullable_to_non_nullable
              as double?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaved: null == isSaved
          ? _value.isSaved
          : isSaved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StampImpl implements _Stamp {
  const _$StampImpl(
      {required this.id,
      required this.userId,
      required this.placeId,
      required this.tier,
      required this.createdAt,
      required this.visibility,
      this.caption,
      final List<String> photoUrls = const [],
      this.audioUrl,
      this.weather,
      this.season,
      this.timeOfDay,
      this.visionScore,
      this.finalScore,
      this.likeCount = 0,
      this.commentCount = 0,
      this.isLiked = false,
      this.isSaved = false})
      : _photoUrls = photoUrls;

  factory _$StampImpl.fromJson(Map<String, dynamic> json) =>
      _$$StampImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String placeId;
  @override
  final AuthTier tier;
  @override
  final DateTime createdAt;
  @override
  final StampVisibility visibility;
  @override
  final String? caption;
  final List<String> _photoUrls;
  @override
  @JsonKey()
  List<String> get photoUrls {
    if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoUrls);
  }

  @override
  final String? audioUrl;
  @override
  final String? weather;
  @override
  final String? season;
  @override
  final String? timeOfDay;
  @override
  final double? visionScore;
  @override
  final double? finalScore;
  @override
  @JsonKey()
  final int likeCount;
  @override
  @JsonKey()
  final int commentCount;
  @override
  @JsonKey()
  final bool isLiked;
  @override
  @JsonKey()
  final bool isSaved;

  @override
  String toString() {
    return 'Stamp(id: $id, userId: $userId, placeId: $placeId, tier: $tier, createdAt: $createdAt, visibility: $visibility, caption: $caption, photoUrls: $photoUrls, audioUrl: $audioUrl, weather: $weather, season: $season, timeOfDay: $timeOfDay, visionScore: $visionScore, finalScore: $finalScore, likeCount: $likeCount, commentCount: $commentCount, isLiked: $isLiked, isSaved: $isSaved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StampImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            const DeepCollectionEquality()
                .equals(other._photoUrls, _photoUrls) &&
            (identical(other.audioUrl, audioUrl) ||
                other.audioUrl == audioUrl) &&
            (identical(other.weather, weather) || other.weather == weather) &&
            (identical(other.season, season) || other.season == season) &&
            (identical(other.timeOfDay, timeOfDay) ||
                other.timeOfDay == timeOfDay) &&
            (identical(other.visionScore, visionScore) ||
                other.visionScore == visionScore) &&
            (identical(other.finalScore, finalScore) ||
                other.finalScore == finalScore) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.isSaved, isSaved) || other.isSaved == isSaved));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      placeId,
      tier,
      createdAt,
      visibility,
      caption,
      const DeepCollectionEquality().hash(_photoUrls),
      audioUrl,
      weather,
      season,
      timeOfDay,
      visionScore,
      finalScore,
      likeCount,
      commentCount,
      isLiked,
      isSaved);

  /// Create a copy of Stamp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StampImplCopyWith<_$StampImpl> get copyWith =>
      __$$StampImplCopyWithImpl<_$StampImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StampImplToJson(
      this,
    );
  }
}

abstract class _Stamp implements Stamp {
  const factory _Stamp(
      {required final String id,
      required final String userId,
      required final String placeId,
      required final AuthTier tier,
      required final DateTime createdAt,
      required final StampVisibility visibility,
      final String? caption,
      final List<String> photoUrls,
      final String? audioUrl,
      final String? weather,
      final String? season,
      final String? timeOfDay,
      final double? visionScore,
      final double? finalScore,
      final int likeCount,
      final int commentCount,
      final bool isLiked,
      final bool isSaved}) = _$StampImpl;

  factory _Stamp.fromJson(Map<String, dynamic> json) = _$StampImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get placeId;
  @override
  AuthTier get tier;
  @override
  DateTime get createdAt;
  @override
  StampVisibility get visibility;
  @override
  String? get caption;
  @override
  List<String> get photoUrls;
  @override
  String? get audioUrl;
  @override
  String? get weather;
  @override
  String? get season;
  @override
  String? get timeOfDay;
  @override
  double? get visionScore;
  @override
  double? get finalScore;
  @override
  int get likeCount;
  @override
  int get commentCount;
  @override
  bool get isLiked;
  @override
  bool get isSaved;

  /// Create a copy of Stamp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StampImplCopyWith<_$StampImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
