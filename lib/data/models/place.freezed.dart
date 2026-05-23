// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return _Place.fromJson(json);
}

/// @nodoc
mixin _$Place {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  SpaceType get spaceType => throw _privateConstructorUsedError;
  PlaceStatus get status => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  int? get pendingCount => throw _privateConstructorUsedError;
  int? get referenceCount => throw _privateConstructorUsedError;
  bool? get hasBadge => throw _privateConstructorUsedError;

  /// Serializes this Place to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Place
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceCopyWith<Place> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceCopyWith<$Res> {
  factory $PlaceCopyWith(Place value, $Res Function(Place) then) =
      _$PlaceCopyWithImpl<$Res, Place>;
  @useResult
  $Res call(
      {String id,
      String name,
      String category,
      SpaceType spaceType,
      PlaceStatus status,
      double lat,
      double lng,
      String? address,
      int? pendingCount,
      int? referenceCount,
      bool? hasBadge});
}

/// @nodoc
class _$PlaceCopyWithImpl<$Res, $Val extends Place>
    implements $PlaceCopyWith<$Res> {
  _$PlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Place
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? spaceType = null,
    Object? status = null,
    Object? lat = null,
    Object? lng = null,
    Object? address = freezed,
    Object? pendingCount = freezed,
    Object? referenceCount = freezed,
    Object? hasBadge = freezed,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      spaceType: null == spaceType
          ? _value.spaceType
          : spaceType // ignore: cast_nullable_to_non_nullable
              as SpaceType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlaceStatus,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingCount: freezed == pendingCount
          ? _value.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int?,
      referenceCount: freezed == referenceCount
          ? _value.referenceCount
          : referenceCount // ignore: cast_nullable_to_non_nullable
              as int?,
      hasBadge: freezed == hasBadge
          ? _value.hasBadge
          : hasBadge // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaceImplCopyWith<$Res> implements $PlaceCopyWith<$Res> {
  factory _$$PlaceImplCopyWith(
          _$PlaceImpl value, $Res Function(_$PlaceImpl) then) =
      __$$PlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String category,
      SpaceType spaceType,
      PlaceStatus status,
      double lat,
      double lng,
      String? address,
      int? pendingCount,
      int? referenceCount,
      bool? hasBadge});
}

/// @nodoc
class __$$PlaceImplCopyWithImpl<$Res>
    extends _$PlaceCopyWithImpl<$Res, _$PlaceImpl>
    implements _$$PlaceImplCopyWith<$Res> {
  __$$PlaceImplCopyWithImpl(
      _$PlaceImpl _value, $Res Function(_$PlaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Place
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? spaceType = null,
    Object? status = null,
    Object? lat = null,
    Object? lng = null,
    Object? address = freezed,
    Object? pendingCount = freezed,
    Object? referenceCount = freezed,
    Object? hasBadge = freezed,
  }) {
    return _then(_$PlaceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      spaceType: null == spaceType
          ? _value.spaceType
          : spaceType // ignore: cast_nullable_to_non_nullable
              as SpaceType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PlaceStatus,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingCount: freezed == pendingCount
          ? _value.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int?,
      referenceCount: freezed == referenceCount
          ? _value.referenceCount
          : referenceCount // ignore: cast_nullable_to_non_nullable
              as int?,
      hasBadge: freezed == hasBadge
          ? _value.hasBadge
          : hasBadge // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceImpl implements _Place {
  const _$PlaceImpl(
      {required this.id,
      required this.name,
      required this.category,
      required this.spaceType,
      required this.status,
      required this.lat,
      required this.lng,
      this.address,
      this.pendingCount,
      this.referenceCount,
      this.hasBadge});

  factory _$PlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final SpaceType spaceType;
  @override
  final PlaceStatus status;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final String? address;
  @override
  final int? pendingCount;
  @override
  final int? referenceCount;
  @override
  final bool? hasBadge;

  @override
  String toString() {
    return 'Place(id: $id, name: $name, category: $category, spaceType: $spaceType, status: $status, lat: $lat, lng: $lng, address: $address, pendingCount: $pendingCount, referenceCount: $referenceCount, hasBadge: $hasBadge)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.spaceType, spaceType) ||
                other.spaceType == spaceType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.referenceCount, referenceCount) ||
                other.referenceCount == referenceCount) &&
            (identical(other.hasBadge, hasBadge) ||
                other.hasBadge == hasBadge));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, category, spaceType,
      status, lat, lng, address, pendingCount, referenceCount, hasBadge);

  /// Create a copy of Place
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceImplCopyWith<_$PlaceImpl> get copyWith =>
      __$$PlaceImplCopyWithImpl<_$PlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceImplToJson(
      this,
    );
  }
}

abstract class _Place implements Place {
  const factory _Place(
      {required final String id,
      required final String name,
      required final String category,
      required final SpaceType spaceType,
      required final PlaceStatus status,
      required final double lat,
      required final double lng,
      final String? address,
      final int? pendingCount,
      final int? referenceCount,
      final bool? hasBadge}) = _$PlaceImpl;

  factory _Place.fromJson(Map<String, dynamic> json) = _$PlaceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get category;
  @override
  SpaceType get spaceType;
  @override
  PlaceStatus get status;
  @override
  double get lat;
  @override
  double get lng;
  @override
  String? get address;
  @override
  int? get pendingCount;
  @override
  int? get referenceCount;
  @override
  bool? get hasBadge;

  /// Create a copy of Place
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceImplCopyWith<_$PlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
