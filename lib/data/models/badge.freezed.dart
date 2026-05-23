// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Badge _$BadgeFromJson(Map<String, dynamic> json) {
  return _Badge.fromJson(json);
}

/// @nodoc
mixin _$Badge {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  BadgeType get badgeType => throw _privateConstructorUsedError;
  String get rarity => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;
  String? get placeId => throw _privateConstructorUsedError;
  bool get isLimited => throw _privateConstructorUsedError;
  DateTime? get availableFrom => throw _privateConstructorUsedError;
  DateTime? get availableUntil => throw _privateConstructorUsedError;
  DateTime? get earnedAt => throw _privateConstructorUsedError;
  bool get isEarned => throw _privateConstructorUsedError;
  bool get isBackfilled => throw _privateConstructorUsedError;

  /// Serializes this Badge to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BadgeCopyWith<Badge> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BadgeCopyWith<$Res> {
  factory $BadgeCopyWith(Badge value, $Res Function(Badge) then) =
      _$BadgeCopyWithImpl<$Res, Badge>;
  @useResult
  $Res call(
      {String id,
      String name,
      BadgeType badgeType,
      String rarity,
      String? description,
      String? iconUrl,
      String? placeId,
      bool isLimited,
      DateTime? availableFrom,
      DateTime? availableUntil,
      DateTime? earnedAt,
      bool isEarned,
      bool isBackfilled});
}

/// @nodoc
class _$BadgeCopyWithImpl<$Res, $Val extends Badge>
    implements $BadgeCopyWith<$Res> {
  _$BadgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? badgeType = null,
    Object? rarity = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? placeId = freezed,
    Object? isLimited = null,
    Object? availableFrom = freezed,
    Object? availableUntil = freezed,
    Object? earnedAt = freezed,
    Object? isEarned = null,
    Object? isBackfilled = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      badgeType: null == badgeType
          ? _value.badgeType
          : badgeType // ignore: cast_nullable_to_non_nullable
              as BadgeType,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
      isLimited: null == isLimited
          ? _value.isLimited
          : isLimited // ignore: cast_nullable_to_non_nullable
              as bool,
      availableFrom: freezed == availableFrom
          ? _value.availableFrom
          : availableFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableUntil: freezed == availableUntil
          ? _value.availableUntil
          : availableUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      earnedAt: freezed == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEarned: null == isEarned
          ? _value.isEarned
          : isEarned // ignore: cast_nullable_to_non_nullable
              as bool,
      isBackfilled: null == isBackfilled
          ? _value.isBackfilled
          : isBackfilled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BadgeImplCopyWith<$Res> implements $BadgeCopyWith<$Res> {
  factory _$$BadgeImplCopyWith(
          _$BadgeImpl value, $Res Function(_$BadgeImpl) then) =
      __$$BadgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      BadgeType badgeType,
      String rarity,
      String? description,
      String? iconUrl,
      String? placeId,
      bool isLimited,
      DateTime? availableFrom,
      DateTime? availableUntil,
      DateTime? earnedAt,
      bool isEarned,
      bool isBackfilled});
}

/// @nodoc
class __$$BadgeImplCopyWithImpl<$Res>
    extends _$BadgeCopyWithImpl<$Res, _$BadgeImpl>
    implements _$$BadgeImplCopyWith<$Res> {
  __$$BadgeImplCopyWithImpl(
      _$BadgeImpl _value, $Res Function(_$BadgeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? badgeType = null,
    Object? rarity = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
    Object? placeId = freezed,
    Object? isLimited = null,
    Object? availableFrom = freezed,
    Object? availableUntil = freezed,
    Object? earnedAt = freezed,
    Object? isEarned = null,
    Object? isBackfilled = null,
  }) {
    return _then(_$BadgeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      badgeType: null == badgeType
          ? _value.badgeType
          : badgeType // ignore: cast_nullable_to_non_nullable
              as BadgeType,
      rarity: null == rarity
          ? _value.rarity
          : rarity // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      placeId: freezed == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String?,
      isLimited: null == isLimited
          ? _value.isLimited
          : isLimited // ignore: cast_nullable_to_non_nullable
              as bool,
      availableFrom: freezed == availableFrom
          ? _value.availableFrom
          : availableFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      availableUntil: freezed == availableUntil
          ? _value.availableUntil
          : availableUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      earnedAt: freezed == earnedAt
          ? _value.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEarned: null == isEarned
          ? _value.isEarned
          : isEarned // ignore: cast_nullable_to_non_nullable
              as bool,
      isBackfilled: null == isBackfilled
          ? _value.isBackfilled
          : isBackfilled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BadgeImpl implements _Badge {
  const _$BadgeImpl(
      {required this.id,
      required this.name,
      required this.badgeType,
      required this.rarity,
      this.description,
      this.iconUrl,
      this.placeId,
      this.isLimited = false,
      this.availableFrom,
      this.availableUntil,
      this.earnedAt,
      this.isEarned = false,
      this.isBackfilled = false});

  factory _$BadgeImpl.fromJson(Map<String, dynamic> json) =>
      _$$BadgeImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final BadgeType badgeType;
  @override
  final String rarity;
  @override
  final String? description;
  @override
  final String? iconUrl;
  @override
  final String? placeId;
  @override
  @JsonKey()
  final bool isLimited;
  @override
  final DateTime? availableFrom;
  @override
  final DateTime? availableUntil;
  @override
  final DateTime? earnedAt;
  @override
  @JsonKey()
  final bool isEarned;
  @override
  @JsonKey()
  final bool isBackfilled;

  @override
  String toString() {
    return 'Badge(id: $id, name: $name, badgeType: $badgeType, rarity: $rarity, description: $description, iconUrl: $iconUrl, placeId: $placeId, isLimited: $isLimited, availableFrom: $availableFrom, availableUntil: $availableUntil, earnedAt: $earnedAt, isEarned: $isEarned, isBackfilled: $isBackfilled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadgeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.badgeType, badgeType) ||
                other.badgeType == badgeType) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.isLimited, isLimited) ||
                other.isLimited == isLimited) &&
            (identical(other.availableFrom, availableFrom) ||
                other.availableFrom == availableFrom) &&
            (identical(other.availableUntil, availableUntil) ||
                other.availableUntil == availableUntil) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt) &&
            (identical(other.isEarned, isEarned) ||
                other.isEarned == isEarned) &&
            (identical(other.isBackfilled, isBackfilled) ||
                other.isBackfilled == isBackfilled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      badgeType,
      rarity,
      description,
      iconUrl,
      placeId,
      isLimited,
      availableFrom,
      availableUntil,
      earnedAt,
      isEarned,
      isBackfilled);

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BadgeImplCopyWith<_$BadgeImpl> get copyWith =>
      __$$BadgeImplCopyWithImpl<_$BadgeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BadgeImplToJson(
      this,
    );
  }
}

abstract class _Badge implements Badge {
  const factory _Badge(
      {required final String id,
      required final String name,
      required final BadgeType badgeType,
      required final String rarity,
      final String? description,
      final String? iconUrl,
      final String? placeId,
      final bool isLimited,
      final DateTime? availableFrom,
      final DateTime? availableUntil,
      final DateTime? earnedAt,
      final bool isEarned,
      final bool isBackfilled}) = _$BadgeImpl;

  factory _Badge.fromJson(Map<String, dynamic> json) = _$BadgeImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  BadgeType get badgeType;
  @override
  String get rarity;
  @override
  String? get description;
  @override
  String? get iconUrl;
  @override
  String? get placeId;
  @override
  bool get isLimited;
  @override
  DateTime? get availableFrom;
  @override
  DateTime? get availableUntil;
  @override
  DateTime? get earnedAt;
  @override
  bool get isEarned;
  @override
  bool get isBackfilled;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BadgeImplCopyWith<_$BadgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
