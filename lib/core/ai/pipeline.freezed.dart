// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pipeline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VideoSweepInput {
  List<CameraImage> get frames => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  double get gpsLat => throw _privateConstructorUsedError;
  double get gpsLng => throw _privateConstructorUsedError;
  double get gpsAccuracy => throw _privateConstructorUsedError;
  List<Map<String, int>> get wifiScan => throw _privateConstructorUsedError;
  Map<String, double> get imuSnapshot => throw _privateConstructorUsedError;

  /// Create a copy of VideoSweepInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoSweepInputCopyWith<VideoSweepInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoSweepInputCopyWith<$Res> {
  factory $VideoSweepInputCopyWith(
          VideoSweepInput value, $Res Function(VideoSweepInput) then) =
      _$VideoSweepInputCopyWithImpl<$Res, VideoSweepInput>;
  @useResult
  $Res call(
      {List<CameraImage> frames,
      int durationMs,
      double gpsLat,
      double gpsLng,
      double gpsAccuracy,
      List<Map<String, int>> wifiScan,
      Map<String, double> imuSnapshot});
}

/// @nodoc
class _$VideoSweepInputCopyWithImpl<$Res, $Val extends VideoSweepInput>
    implements $VideoSweepInputCopyWith<$Res> {
  _$VideoSweepInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoSweepInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frames = null,
    Object? durationMs = null,
    Object? gpsLat = null,
    Object? gpsLng = null,
    Object? gpsAccuracy = null,
    Object? wifiScan = null,
    Object? imuSnapshot = null,
  }) {
    return _then(_value.copyWith(
      frames: null == frames
          ? _value.frames
          : frames // ignore: cast_nullable_to_non_nullable
              as List<CameraImage>,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      gpsLat: null == gpsLat
          ? _value.gpsLat
          : gpsLat // ignore: cast_nullable_to_non_nullable
              as double,
      gpsLng: null == gpsLng
          ? _value.gpsLng
          : gpsLng // ignore: cast_nullable_to_non_nullable
              as double,
      gpsAccuracy: null == gpsAccuracy
          ? _value.gpsAccuracy
          : gpsAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      wifiScan: null == wifiScan
          ? _value.wifiScan
          : wifiScan // ignore: cast_nullable_to_non_nullable
              as List<Map<String, int>>,
      imuSnapshot: null == imuSnapshot
          ? _value.imuSnapshot
          : imuSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoSweepInputImplCopyWith<$Res>
    implements $VideoSweepInputCopyWith<$Res> {
  factory _$$VideoSweepInputImplCopyWith(_$VideoSweepInputImpl value,
          $Res Function(_$VideoSweepInputImpl) then) =
      __$$VideoSweepInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CameraImage> frames,
      int durationMs,
      double gpsLat,
      double gpsLng,
      double gpsAccuracy,
      List<Map<String, int>> wifiScan,
      Map<String, double> imuSnapshot});
}

/// @nodoc
class __$$VideoSweepInputImplCopyWithImpl<$Res>
    extends _$VideoSweepInputCopyWithImpl<$Res, _$VideoSweepInputImpl>
    implements _$$VideoSweepInputImplCopyWith<$Res> {
  __$$VideoSweepInputImplCopyWithImpl(
      _$VideoSweepInputImpl _value, $Res Function(_$VideoSweepInputImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoSweepInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frames = null,
    Object? durationMs = null,
    Object? gpsLat = null,
    Object? gpsLng = null,
    Object? gpsAccuracy = null,
    Object? wifiScan = null,
    Object? imuSnapshot = null,
  }) {
    return _then(_$VideoSweepInputImpl(
      frames: null == frames
          ? _value._frames
          : frames // ignore: cast_nullable_to_non_nullable
              as List<CameraImage>,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      gpsLat: null == gpsLat
          ? _value.gpsLat
          : gpsLat // ignore: cast_nullable_to_non_nullable
              as double,
      gpsLng: null == gpsLng
          ? _value.gpsLng
          : gpsLng // ignore: cast_nullable_to_non_nullable
              as double,
      gpsAccuracy: null == gpsAccuracy
          ? _value.gpsAccuracy
          : gpsAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      wifiScan: null == wifiScan
          ? _value._wifiScan
          : wifiScan // ignore: cast_nullable_to_non_nullable
              as List<Map<String, int>>,
      imuSnapshot: null == imuSnapshot
          ? _value._imuSnapshot
          : imuSnapshot // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

/// @nodoc

class _$VideoSweepInputImpl implements _VideoSweepInput {
  const _$VideoSweepInputImpl(
      {required final List<CameraImage> frames,
      required this.durationMs,
      required this.gpsLat,
      required this.gpsLng,
      required this.gpsAccuracy,
      required final List<Map<String, int>> wifiScan,
      required final Map<String, double> imuSnapshot})
      : _frames = frames,
        _wifiScan = wifiScan,
        _imuSnapshot = imuSnapshot;

  final List<CameraImage> _frames;
  @override
  List<CameraImage> get frames {
    if (_frames is EqualUnmodifiableListView) return _frames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_frames);
  }

  @override
  final int durationMs;
  @override
  final double gpsLat;
  @override
  final double gpsLng;
  @override
  final double gpsAccuracy;
  final List<Map<String, int>> _wifiScan;
  @override
  List<Map<String, int>> get wifiScan {
    if (_wifiScan is EqualUnmodifiableListView) return _wifiScan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wifiScan);
  }

  final Map<String, double> _imuSnapshot;
  @override
  Map<String, double> get imuSnapshot {
    if (_imuSnapshot is EqualUnmodifiableMapView) return _imuSnapshot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_imuSnapshot);
  }

  @override
  String toString() {
    return 'VideoSweepInput(frames: $frames, durationMs: $durationMs, gpsLat: $gpsLat, gpsLng: $gpsLng, gpsAccuracy: $gpsAccuracy, wifiScan: $wifiScan, imuSnapshot: $imuSnapshot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoSweepInputImpl &&
            const DeepCollectionEquality().equals(other._frames, _frames) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.gpsLat, gpsLat) || other.gpsLat == gpsLat) &&
            (identical(other.gpsLng, gpsLng) || other.gpsLng == gpsLng) &&
            (identical(other.gpsAccuracy, gpsAccuracy) ||
                other.gpsAccuracy == gpsAccuracy) &&
            const DeepCollectionEquality().equals(other._wifiScan, _wifiScan) &&
            const DeepCollectionEquality()
                .equals(other._imuSnapshot, _imuSnapshot));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_frames),
      durationMs,
      gpsLat,
      gpsLng,
      gpsAccuracy,
      const DeepCollectionEquality().hash(_wifiScan),
      const DeepCollectionEquality().hash(_imuSnapshot));

  /// Create a copy of VideoSweepInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoSweepInputImplCopyWith<_$VideoSweepInputImpl> get copyWith =>
      __$$VideoSweepInputImplCopyWithImpl<_$VideoSweepInputImpl>(
          this, _$identity);
}

abstract class _VideoSweepInput implements VideoSweepInput {
  const factory _VideoSweepInput(
      {required final List<CameraImage> frames,
      required final int durationMs,
      required final double gpsLat,
      required final double gpsLng,
      required final double gpsAccuracy,
      required final List<Map<String, int>> wifiScan,
      required final Map<String, double> imuSnapshot}) = _$VideoSweepInputImpl;

  @override
  List<CameraImage> get frames;
  @override
  int get durationMs;
  @override
  double get gpsLat;
  @override
  double get gpsLng;
  @override
  double get gpsAccuracy;
  @override
  List<Map<String, int>> get wifiScan;
  @override
  Map<String, double> get imuSnapshot;

  /// Create a copy of VideoSweepInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoSweepInputImplCopyWith<_$VideoSweepInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LivenessResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Float32List depthMap,
            List<Float32List> flowVectors,
            double depthVariance,
            double flowMagnitude,
            bool stationaryFlag)
        pass,
    required TResult Function(LivenessFailReason reason, String userMessage)
        fail,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Float32List depthMap, List<Float32List> flowVectors,
            double depthVariance, double flowMagnitude, bool stationaryFlag)?
        pass,
    TResult? Function(LivenessFailReason reason, String userMessage)? fail,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Float32List depthMap, List<Float32List> flowVectors,
            double depthVariance, double flowMagnitude, bool stationaryFlag)?
        pass,
    TResult Function(LivenessFailReason reason, String userMessage)? fail,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LivenessPass value) pass,
    required TResult Function(LivenessFail value) fail,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LivenessPass value)? pass,
    TResult? Function(LivenessFail value)? fail,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LivenessPass value)? pass,
    TResult Function(LivenessFail value)? fail,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LivenessResultCopyWith<$Res> {
  factory $LivenessResultCopyWith(
          LivenessResult value, $Res Function(LivenessResult) then) =
      _$LivenessResultCopyWithImpl<$Res, LivenessResult>;
}

/// @nodoc
class _$LivenessResultCopyWithImpl<$Res, $Val extends LivenessResult>
    implements $LivenessResultCopyWith<$Res> {
  _$LivenessResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LivenessResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LivenessPassImplCopyWith<$Res> {
  factory _$$LivenessPassImplCopyWith(
          _$LivenessPassImpl value, $Res Function(_$LivenessPassImpl) then) =
      __$$LivenessPassImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {Float32List depthMap,
      List<Float32List> flowVectors,
      double depthVariance,
      double flowMagnitude,
      bool stationaryFlag});
}

/// @nodoc
class __$$LivenessPassImplCopyWithImpl<$Res>
    extends _$LivenessResultCopyWithImpl<$Res, _$LivenessPassImpl>
    implements _$$LivenessPassImplCopyWith<$Res> {
  __$$LivenessPassImplCopyWithImpl(
      _$LivenessPassImpl _value, $Res Function(_$LivenessPassImpl) _then)
      : super(_value, _then);

  /// Create a copy of LivenessResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? depthMap = null,
    Object? flowVectors = null,
    Object? depthVariance = null,
    Object? flowMagnitude = null,
    Object? stationaryFlag = null,
  }) {
    return _then(_$LivenessPassImpl(
      depthMap: null == depthMap
          ? _value.depthMap
          : depthMap // ignore: cast_nullable_to_non_nullable
              as Float32List,
      flowVectors: null == flowVectors
          ? _value._flowVectors
          : flowVectors // ignore: cast_nullable_to_non_nullable
              as List<Float32List>,
      depthVariance: null == depthVariance
          ? _value.depthVariance
          : depthVariance // ignore: cast_nullable_to_non_nullable
              as double,
      flowMagnitude: null == flowMagnitude
          ? _value.flowMagnitude
          : flowMagnitude // ignore: cast_nullable_to_non_nullable
              as double,
      stationaryFlag: null == stationaryFlag
          ? _value.stationaryFlag
          : stationaryFlag // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LivenessPassImpl implements LivenessPass {
  const _$LivenessPassImpl(
      {required this.depthMap,
      required final List<Float32List> flowVectors,
      required this.depthVariance,
      required this.flowMagnitude,
      this.stationaryFlag = false})
      : _flowVectors = flowVectors;

  @override
  final Float32List depthMap;
  final List<Float32List> _flowVectors;
  @override
  List<Float32List> get flowVectors {
    if (_flowVectors is EqualUnmodifiableListView) return _flowVectors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_flowVectors);
  }

  @override
  final double depthVariance;
  @override
  final double flowMagnitude;
  @override
  @JsonKey()
  final bool stationaryFlag;

  @override
  String toString() {
    return 'LivenessResult.pass(depthMap: $depthMap, flowVectors: $flowVectors, depthVariance: $depthVariance, flowMagnitude: $flowMagnitude, stationaryFlag: $stationaryFlag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LivenessPassImpl &&
            const DeepCollectionEquality().equals(other.depthMap, depthMap) &&
            const DeepCollectionEquality()
                .equals(other._flowVectors, _flowVectors) &&
            (identical(other.depthVariance, depthVariance) ||
                other.depthVariance == depthVariance) &&
            (identical(other.flowMagnitude, flowMagnitude) ||
                other.flowMagnitude == flowMagnitude) &&
            (identical(other.stationaryFlag, stationaryFlag) ||
                other.stationaryFlag == stationaryFlag));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(depthMap),
      const DeepCollectionEquality().hash(_flowVectors),
      depthVariance,
      flowMagnitude,
      stationaryFlag);

  /// Create a copy of LivenessResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LivenessPassImplCopyWith<_$LivenessPassImpl> get copyWith =>
      __$$LivenessPassImplCopyWithImpl<_$LivenessPassImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Float32List depthMap,
            List<Float32List> flowVectors,
            double depthVariance,
            double flowMagnitude,
            bool stationaryFlag)
        pass,
    required TResult Function(LivenessFailReason reason, String userMessage)
        fail,
  }) {
    return pass(
        depthMap, flowVectors, depthVariance, flowMagnitude, stationaryFlag);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Float32List depthMap, List<Float32List> flowVectors,
            double depthVariance, double flowMagnitude, bool stationaryFlag)?
        pass,
    TResult? Function(LivenessFailReason reason, String userMessage)? fail,
  }) {
    return pass?.call(
        depthMap, flowVectors, depthVariance, flowMagnitude, stationaryFlag);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Float32List depthMap, List<Float32List> flowVectors,
            double depthVariance, double flowMagnitude, bool stationaryFlag)?
        pass,
    TResult Function(LivenessFailReason reason, String userMessage)? fail,
    required TResult orElse(),
  }) {
    if (pass != null) {
      return pass(
          depthMap, flowVectors, depthVariance, flowMagnitude, stationaryFlag);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LivenessPass value) pass,
    required TResult Function(LivenessFail value) fail,
  }) {
    return pass(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LivenessPass value)? pass,
    TResult? Function(LivenessFail value)? fail,
  }) {
    return pass?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LivenessPass value)? pass,
    TResult Function(LivenessFail value)? fail,
    required TResult orElse(),
  }) {
    if (pass != null) {
      return pass(this);
    }
    return orElse();
  }
}

abstract class LivenessPass implements LivenessResult {
  const factory LivenessPass(
      {required final Float32List depthMap,
      required final List<Float32List> flowVectors,
      required final double depthVariance,
      required final double flowMagnitude,
      final bool stationaryFlag}) = _$LivenessPassImpl;

  Float32List get depthMap;
  List<Float32List> get flowVectors;
  double get depthVariance;
  double get flowMagnitude;
  bool get stationaryFlag;

  /// Create a copy of LivenessResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LivenessPassImplCopyWith<_$LivenessPassImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LivenessFailImplCopyWith<$Res> {
  factory _$$LivenessFailImplCopyWith(
          _$LivenessFailImpl value, $Res Function(_$LivenessFailImpl) then) =
      __$$LivenessFailImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LivenessFailReason reason, String userMessage});
}

/// @nodoc
class __$$LivenessFailImplCopyWithImpl<$Res>
    extends _$LivenessResultCopyWithImpl<$Res, _$LivenessFailImpl>
    implements _$$LivenessFailImplCopyWith<$Res> {
  __$$LivenessFailImplCopyWithImpl(
      _$LivenessFailImpl _value, $Res Function(_$LivenessFailImpl) _then)
      : super(_value, _then);

  /// Create a copy of LivenessResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
    Object? userMessage = null,
  }) {
    return _then(_$LivenessFailImpl(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as LivenessFailReason,
      userMessage: null == userMessage
          ? _value.userMessage
          : userMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LivenessFailImpl implements LivenessFail {
  const _$LivenessFailImpl({required this.reason, required this.userMessage});

  @override
  final LivenessFailReason reason;
  @override
  final String userMessage;

  @override
  String toString() {
    return 'LivenessResult.fail(reason: $reason, userMessage: $userMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LivenessFailImpl &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.userMessage, userMessage) ||
                other.userMessage == userMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason, userMessage);

  /// Create a copy of LivenessResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LivenessFailImplCopyWith<_$LivenessFailImpl> get copyWith =>
      __$$LivenessFailImplCopyWithImpl<_$LivenessFailImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Float32List depthMap,
            List<Float32List> flowVectors,
            double depthVariance,
            double flowMagnitude,
            bool stationaryFlag)
        pass,
    required TResult Function(LivenessFailReason reason, String userMessage)
        fail,
  }) {
    return fail(reason, userMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Float32List depthMap, List<Float32List> flowVectors,
            double depthVariance, double flowMagnitude, bool stationaryFlag)?
        pass,
    TResult? Function(LivenessFailReason reason, String userMessage)? fail,
  }) {
    return fail?.call(reason, userMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Float32List depthMap, List<Float32List> flowVectors,
            double depthVariance, double flowMagnitude, bool stationaryFlag)?
        pass,
    TResult Function(LivenessFailReason reason, String userMessage)? fail,
    required TResult orElse(),
  }) {
    if (fail != null) {
      return fail(reason, userMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LivenessPass value) pass,
    required TResult Function(LivenessFail value) fail,
  }) {
    return fail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LivenessPass value)? pass,
    TResult? Function(LivenessFail value)? fail,
  }) {
    return fail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LivenessPass value)? pass,
    TResult Function(LivenessFail value)? fail,
    required TResult orElse(),
  }) {
    if (fail != null) {
      return fail(this);
    }
    return orElse();
  }
}

abstract class LivenessFail implements LivenessResult {
  const factory LivenessFail(
      {required final LivenessFailReason reason,
      required final String userMessage}) = _$LivenessFailImpl;

  LivenessFailReason get reason;
  String get userMessage;

  /// Create a copy of LivenessResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LivenessFailImplCopyWith<_$LivenessFailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SceneMatchResult {
  AuthRoute get route => throw _privateConstructorUsedError;
  bool get anchorDetected => throw _privateConstructorUsedError;
  double get embeddingScore => throw _privateConstructorUsedError;
  double get keypointScore => throw _privateConstructorUsedError;
  double get depthScore => throw _privateConstructorUsedError;
  int get inlierCount => throw _privateConstructorUsedError;
  Float32List get embedding => throw _privateConstructorUsedError;

  /// Create a copy of SceneMatchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SceneMatchResultCopyWith<SceneMatchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SceneMatchResultCopyWith<$Res> {
  factory $SceneMatchResultCopyWith(
          SceneMatchResult value, $Res Function(SceneMatchResult) then) =
      _$SceneMatchResultCopyWithImpl<$Res, SceneMatchResult>;
  @useResult
  $Res call(
      {AuthRoute route,
      bool anchorDetected,
      double embeddingScore,
      double keypointScore,
      double depthScore,
      int inlierCount,
      Float32List embedding});
}

/// @nodoc
class _$SceneMatchResultCopyWithImpl<$Res, $Val extends SceneMatchResult>
    implements $SceneMatchResultCopyWith<$Res> {
  _$SceneMatchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SceneMatchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? route = null,
    Object? anchorDetected = null,
    Object? embeddingScore = null,
    Object? keypointScore = null,
    Object? depthScore = null,
    Object? inlierCount = null,
    Object? embedding = null,
  }) {
    return _then(_value.copyWith(
      route: null == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as AuthRoute,
      anchorDetected: null == anchorDetected
          ? _value.anchorDetected
          : anchorDetected // ignore: cast_nullable_to_non_nullable
              as bool,
      embeddingScore: null == embeddingScore
          ? _value.embeddingScore
          : embeddingScore // ignore: cast_nullable_to_non_nullable
              as double,
      keypointScore: null == keypointScore
          ? _value.keypointScore
          : keypointScore // ignore: cast_nullable_to_non_nullable
              as double,
      depthScore: null == depthScore
          ? _value.depthScore
          : depthScore // ignore: cast_nullable_to_non_nullable
              as double,
      inlierCount: null == inlierCount
          ? _value.inlierCount
          : inlierCount // ignore: cast_nullable_to_non_nullable
              as int,
      embedding: null == embedding
          ? _value.embedding
          : embedding // ignore: cast_nullable_to_non_nullable
              as Float32List,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SceneMatchResultImplCopyWith<$Res>
    implements $SceneMatchResultCopyWith<$Res> {
  factory _$$SceneMatchResultImplCopyWith(_$SceneMatchResultImpl value,
          $Res Function(_$SceneMatchResultImpl) then) =
      __$$SceneMatchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthRoute route,
      bool anchorDetected,
      double embeddingScore,
      double keypointScore,
      double depthScore,
      int inlierCount,
      Float32List embedding});
}

/// @nodoc
class __$$SceneMatchResultImplCopyWithImpl<$Res>
    extends _$SceneMatchResultCopyWithImpl<$Res, _$SceneMatchResultImpl>
    implements _$$SceneMatchResultImplCopyWith<$Res> {
  __$$SceneMatchResultImplCopyWithImpl(_$SceneMatchResultImpl _value,
      $Res Function(_$SceneMatchResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of SceneMatchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? route = null,
    Object? anchorDetected = null,
    Object? embeddingScore = null,
    Object? keypointScore = null,
    Object? depthScore = null,
    Object? inlierCount = null,
    Object? embedding = null,
  }) {
    return _then(_$SceneMatchResultImpl(
      route: null == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as AuthRoute,
      anchorDetected: null == anchorDetected
          ? _value.anchorDetected
          : anchorDetected // ignore: cast_nullable_to_non_nullable
              as bool,
      embeddingScore: null == embeddingScore
          ? _value.embeddingScore
          : embeddingScore // ignore: cast_nullable_to_non_nullable
              as double,
      keypointScore: null == keypointScore
          ? _value.keypointScore
          : keypointScore // ignore: cast_nullable_to_non_nullable
              as double,
      depthScore: null == depthScore
          ? _value.depthScore
          : depthScore // ignore: cast_nullable_to_non_nullable
              as double,
      inlierCount: null == inlierCount
          ? _value.inlierCount
          : inlierCount // ignore: cast_nullable_to_non_nullable
              as int,
      embedding: null == embedding
          ? _value.embedding
          : embedding // ignore: cast_nullable_to_non_nullable
              as Float32List,
    ));
  }
}

/// @nodoc

class _$SceneMatchResultImpl implements _SceneMatchResult {
  const _$SceneMatchResultImpl(
      {required this.route,
      required this.anchorDetected,
      required this.embeddingScore,
      required this.keypointScore,
      required this.depthScore,
      required this.inlierCount,
      required this.embedding});

  @override
  final AuthRoute route;
  @override
  final bool anchorDetected;
  @override
  final double embeddingScore;
  @override
  final double keypointScore;
  @override
  final double depthScore;
  @override
  final int inlierCount;
  @override
  final Float32List embedding;

  @override
  String toString() {
    return 'SceneMatchResult(route: $route, anchorDetected: $anchorDetected, embeddingScore: $embeddingScore, keypointScore: $keypointScore, depthScore: $depthScore, inlierCount: $inlierCount, embedding: $embedding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SceneMatchResultImpl &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.anchorDetected, anchorDetected) ||
                other.anchorDetected == anchorDetected) &&
            (identical(other.embeddingScore, embeddingScore) ||
                other.embeddingScore == embeddingScore) &&
            (identical(other.keypointScore, keypointScore) ||
                other.keypointScore == keypointScore) &&
            (identical(other.depthScore, depthScore) ||
                other.depthScore == depthScore) &&
            (identical(other.inlierCount, inlierCount) ||
                other.inlierCount == inlierCount) &&
            const DeepCollectionEquality().equals(other.embedding, embedding));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      route,
      anchorDetected,
      embeddingScore,
      keypointScore,
      depthScore,
      inlierCount,
      const DeepCollectionEquality().hash(embedding));

  /// Create a copy of SceneMatchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SceneMatchResultImplCopyWith<_$SceneMatchResultImpl> get copyWith =>
      __$$SceneMatchResultImplCopyWithImpl<_$SceneMatchResultImpl>(
          this, _$identity);
}

abstract class _SceneMatchResult implements SceneMatchResult {
  const factory _SceneMatchResult(
      {required final AuthRoute route,
      required final bool anchorDetected,
      required final double embeddingScore,
      required final double keypointScore,
      required final double depthScore,
      required final int inlierCount,
      required final Float32List embedding}) = _$SceneMatchResultImpl;

  @override
  AuthRoute get route;
  @override
  bool get anchorDetected;
  @override
  double get embeddingScore;
  @override
  double get keypointScore;
  @override
  double get depthScore;
  @override
  int get inlierCount;
  @override
  Float32List get embedding;

  /// Create a copy of SceneMatchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SceneMatchResultImplCopyWith<_$SceneMatchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SensorFusionResult {
  double get sensorScore => throw _privateConstructorUsedError;
  bool get timestampConsistent => throw _privateConstructorUsedError;
  double get distanceFromPlaceM => throw _privateConstructorUsedError;
  double get wifiSimilarity => throw _privateConstructorUsedError;
  bool get imuMovementDetected => throw _privateConstructorUsedError;

  /// Create a copy of SensorFusionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SensorFusionResultCopyWith<SensorFusionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensorFusionResultCopyWith<$Res> {
  factory $SensorFusionResultCopyWith(
          SensorFusionResult value, $Res Function(SensorFusionResult) then) =
      _$SensorFusionResultCopyWithImpl<$Res, SensorFusionResult>;
  @useResult
  $Res call(
      {double sensorScore,
      bool timestampConsistent,
      double distanceFromPlaceM,
      double wifiSimilarity,
      bool imuMovementDetected});
}

/// @nodoc
class _$SensorFusionResultCopyWithImpl<$Res, $Val extends SensorFusionResult>
    implements $SensorFusionResultCopyWith<$Res> {
  _$SensorFusionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SensorFusionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sensorScore = null,
    Object? timestampConsistent = null,
    Object? distanceFromPlaceM = null,
    Object? wifiSimilarity = null,
    Object? imuMovementDetected = null,
  }) {
    return _then(_value.copyWith(
      sensorScore: null == sensorScore
          ? _value.sensorScore
          : sensorScore // ignore: cast_nullable_to_non_nullable
              as double,
      timestampConsistent: null == timestampConsistent
          ? _value.timestampConsistent
          : timestampConsistent // ignore: cast_nullable_to_non_nullable
              as bool,
      distanceFromPlaceM: null == distanceFromPlaceM
          ? _value.distanceFromPlaceM
          : distanceFromPlaceM // ignore: cast_nullable_to_non_nullable
              as double,
      wifiSimilarity: null == wifiSimilarity
          ? _value.wifiSimilarity
          : wifiSimilarity // ignore: cast_nullable_to_non_nullable
              as double,
      imuMovementDetected: null == imuMovementDetected
          ? _value.imuMovementDetected
          : imuMovementDetected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SensorFusionResultImplCopyWith<$Res>
    implements $SensorFusionResultCopyWith<$Res> {
  factory _$$SensorFusionResultImplCopyWith(_$SensorFusionResultImpl value,
          $Res Function(_$SensorFusionResultImpl) then) =
      __$$SensorFusionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double sensorScore,
      bool timestampConsistent,
      double distanceFromPlaceM,
      double wifiSimilarity,
      bool imuMovementDetected});
}

/// @nodoc
class __$$SensorFusionResultImplCopyWithImpl<$Res>
    extends _$SensorFusionResultCopyWithImpl<$Res, _$SensorFusionResultImpl>
    implements _$$SensorFusionResultImplCopyWith<$Res> {
  __$$SensorFusionResultImplCopyWithImpl(_$SensorFusionResultImpl _value,
      $Res Function(_$SensorFusionResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of SensorFusionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sensorScore = null,
    Object? timestampConsistent = null,
    Object? distanceFromPlaceM = null,
    Object? wifiSimilarity = null,
    Object? imuMovementDetected = null,
  }) {
    return _then(_$SensorFusionResultImpl(
      sensorScore: null == sensorScore
          ? _value.sensorScore
          : sensorScore // ignore: cast_nullable_to_non_nullable
              as double,
      timestampConsistent: null == timestampConsistent
          ? _value.timestampConsistent
          : timestampConsistent // ignore: cast_nullable_to_non_nullable
              as bool,
      distanceFromPlaceM: null == distanceFromPlaceM
          ? _value.distanceFromPlaceM
          : distanceFromPlaceM // ignore: cast_nullable_to_non_nullable
              as double,
      wifiSimilarity: null == wifiSimilarity
          ? _value.wifiSimilarity
          : wifiSimilarity // ignore: cast_nullable_to_non_nullable
              as double,
      imuMovementDetected: null == imuMovementDetected
          ? _value.imuMovementDetected
          : imuMovementDetected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SensorFusionResultImpl implements _SensorFusionResult {
  const _$SensorFusionResultImpl(
      {required this.sensorScore,
      required this.timestampConsistent,
      required this.distanceFromPlaceM,
      required this.wifiSimilarity,
      required this.imuMovementDetected});

  @override
  final double sensorScore;
  @override
  final bool timestampConsistent;
  @override
  final double distanceFromPlaceM;
  @override
  final double wifiSimilarity;
  @override
  final bool imuMovementDetected;

  @override
  String toString() {
    return 'SensorFusionResult(sensorScore: $sensorScore, timestampConsistent: $timestampConsistent, distanceFromPlaceM: $distanceFromPlaceM, wifiSimilarity: $wifiSimilarity, imuMovementDetected: $imuMovementDetected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SensorFusionResultImpl &&
            (identical(other.sensorScore, sensorScore) ||
                other.sensorScore == sensorScore) &&
            (identical(other.timestampConsistent, timestampConsistent) ||
                other.timestampConsistent == timestampConsistent) &&
            (identical(other.distanceFromPlaceM, distanceFromPlaceM) ||
                other.distanceFromPlaceM == distanceFromPlaceM) &&
            (identical(other.wifiSimilarity, wifiSimilarity) ||
                other.wifiSimilarity == wifiSimilarity) &&
            (identical(other.imuMovementDetected, imuMovementDetected) ||
                other.imuMovementDetected == imuMovementDetected));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sensorScore, timestampConsistent,
      distanceFromPlaceM, wifiSimilarity, imuMovementDetected);

  /// Create a copy of SensorFusionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SensorFusionResultImplCopyWith<_$SensorFusionResultImpl> get copyWith =>
      __$$SensorFusionResultImplCopyWithImpl<_$SensorFusionResultImpl>(
          this, _$identity);
}

abstract class _SensorFusionResult implements SensorFusionResult {
  const factory _SensorFusionResult(
      {required final double sensorScore,
      required final bool timestampConsistent,
      required final double distanceFromPlaceM,
      required final double wifiSimilarity,
      required final bool imuMovementDetected}) = _$SensorFusionResultImpl;

  @override
  double get sensorScore;
  @override
  bool get timestampConsistent;
  @override
  double get distanceFromPlaceM;
  @override
  double get wifiSimilarity;
  @override
  bool get imuMovementDetected;

  /// Create a copy of SensorFusionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SensorFusionResultImplCopyWith<_$SensorFusionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VerificationResult {
  double get finalScore => throw _privateConstructorUsedError;
  bool get passed => throw _privateConstructorUsedError;
  bool get needsChallenge => throw _privateConstructorUsedError;
  LivenessResult get liveness => throw _privateConstructorUsedError;
  SceneMatchResult get scene => throw _privateConstructorUsedError;
  SensorFusionResult get sensor => throw _privateConstructorUsedError;
  String get certificateHash => throw _privateConstructorUsedError;
  String get placeId => throw _privateConstructorUsedError;
  DateTime get verifiedAt => throw _privateConstructorUsedError;

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerificationResultCopyWith<VerificationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerificationResultCopyWith<$Res> {
  factory $VerificationResultCopyWith(
          VerificationResult value, $Res Function(VerificationResult) then) =
      _$VerificationResultCopyWithImpl<$Res, VerificationResult>;
  @useResult
  $Res call(
      {double finalScore,
      bool passed,
      bool needsChallenge,
      LivenessResult liveness,
      SceneMatchResult scene,
      SensorFusionResult sensor,
      String certificateHash,
      String placeId,
      DateTime verifiedAt});

  $LivenessResultCopyWith<$Res> get liveness;
  $SceneMatchResultCopyWith<$Res> get scene;
  $SensorFusionResultCopyWith<$Res> get sensor;
}

/// @nodoc
class _$VerificationResultCopyWithImpl<$Res, $Val extends VerificationResult>
    implements $VerificationResultCopyWith<$Res> {
  _$VerificationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? finalScore = null,
    Object? passed = null,
    Object? needsChallenge = null,
    Object? liveness = null,
    Object? scene = null,
    Object? sensor = null,
    Object? certificateHash = null,
    Object? placeId = null,
    Object? verifiedAt = null,
  }) {
    return _then(_value.copyWith(
      finalScore: null == finalScore
          ? _value.finalScore
          : finalScore // ignore: cast_nullable_to_non_nullable
              as double,
      passed: null == passed
          ? _value.passed
          : passed // ignore: cast_nullable_to_non_nullable
              as bool,
      needsChallenge: null == needsChallenge
          ? _value.needsChallenge
          : needsChallenge // ignore: cast_nullable_to_non_nullable
              as bool,
      liveness: null == liveness
          ? _value.liveness
          : liveness // ignore: cast_nullable_to_non_nullable
              as LivenessResult,
      scene: null == scene
          ? _value.scene
          : scene // ignore: cast_nullable_to_non_nullable
              as SceneMatchResult,
      sensor: null == sensor
          ? _value.sensor
          : sensor // ignore: cast_nullable_to_non_nullable
              as SensorFusionResult,
      certificateHash: null == certificateHash
          ? _value.certificateHash
          : certificateHash // ignore: cast_nullable_to_non_nullable
              as String,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      verifiedAt: null == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LivenessResultCopyWith<$Res> get liveness {
    return $LivenessResultCopyWith<$Res>(_value.liveness, (value) {
      return _then(_value.copyWith(liveness: value) as $Val);
    });
  }

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SceneMatchResultCopyWith<$Res> get scene {
    return $SceneMatchResultCopyWith<$Res>(_value.scene, (value) {
      return _then(_value.copyWith(scene: value) as $Val);
    });
  }

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SensorFusionResultCopyWith<$Res> get sensor {
    return $SensorFusionResultCopyWith<$Res>(_value.sensor, (value) {
      return _then(_value.copyWith(sensor: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerificationResultImplCopyWith<$Res>
    implements $VerificationResultCopyWith<$Res> {
  factory _$$VerificationResultImplCopyWith(_$VerificationResultImpl value,
          $Res Function(_$VerificationResultImpl) then) =
      __$$VerificationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double finalScore,
      bool passed,
      bool needsChallenge,
      LivenessResult liveness,
      SceneMatchResult scene,
      SensorFusionResult sensor,
      String certificateHash,
      String placeId,
      DateTime verifiedAt});

  @override
  $LivenessResultCopyWith<$Res> get liveness;
  @override
  $SceneMatchResultCopyWith<$Res> get scene;
  @override
  $SensorFusionResultCopyWith<$Res> get sensor;
}

/// @nodoc
class __$$VerificationResultImplCopyWithImpl<$Res>
    extends _$VerificationResultCopyWithImpl<$Res, _$VerificationResultImpl>
    implements _$$VerificationResultImplCopyWith<$Res> {
  __$$VerificationResultImplCopyWithImpl(_$VerificationResultImpl _value,
      $Res Function(_$VerificationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? finalScore = null,
    Object? passed = null,
    Object? needsChallenge = null,
    Object? liveness = null,
    Object? scene = null,
    Object? sensor = null,
    Object? certificateHash = null,
    Object? placeId = null,
    Object? verifiedAt = null,
  }) {
    return _then(_$VerificationResultImpl(
      finalScore: null == finalScore
          ? _value.finalScore
          : finalScore // ignore: cast_nullable_to_non_nullable
              as double,
      passed: null == passed
          ? _value.passed
          : passed // ignore: cast_nullable_to_non_nullable
              as bool,
      needsChallenge: null == needsChallenge
          ? _value.needsChallenge
          : needsChallenge // ignore: cast_nullable_to_non_nullable
              as bool,
      liveness: null == liveness
          ? _value.liveness
          : liveness // ignore: cast_nullable_to_non_nullable
              as LivenessResult,
      scene: null == scene
          ? _value.scene
          : scene // ignore: cast_nullable_to_non_nullable
              as SceneMatchResult,
      sensor: null == sensor
          ? _value.sensor
          : sensor // ignore: cast_nullable_to_non_nullable
              as SensorFusionResult,
      certificateHash: null == certificateHash
          ? _value.certificateHash
          : certificateHash // ignore: cast_nullable_to_non_nullable
              as String,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      verifiedAt: null == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$VerificationResultImpl implements _VerificationResult {
  const _$VerificationResultImpl(
      {required this.finalScore,
      required this.passed,
      required this.needsChallenge,
      required this.liveness,
      required this.scene,
      required this.sensor,
      required this.certificateHash,
      required this.placeId,
      required this.verifiedAt});

  @override
  final double finalScore;
  @override
  final bool passed;
  @override
  final bool needsChallenge;
  @override
  final LivenessResult liveness;
  @override
  final SceneMatchResult scene;
  @override
  final SensorFusionResult sensor;
  @override
  final String certificateHash;
  @override
  final String placeId;
  @override
  final DateTime verifiedAt;

  @override
  String toString() {
    return 'VerificationResult(finalScore: $finalScore, passed: $passed, needsChallenge: $needsChallenge, liveness: $liveness, scene: $scene, sensor: $sensor, certificateHash: $certificateHash, placeId: $placeId, verifiedAt: $verifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerificationResultImpl &&
            (identical(other.finalScore, finalScore) ||
                other.finalScore == finalScore) &&
            (identical(other.passed, passed) || other.passed == passed) &&
            (identical(other.needsChallenge, needsChallenge) ||
                other.needsChallenge == needsChallenge) &&
            (identical(other.liveness, liveness) ||
                other.liveness == liveness) &&
            (identical(other.scene, scene) || other.scene == scene) &&
            (identical(other.sensor, sensor) || other.sensor == sensor) &&
            (identical(other.certificateHash, certificateHash) ||
                other.certificateHash == certificateHash) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      finalScore,
      passed,
      needsChallenge,
      liveness,
      scene,
      sensor,
      certificateHash,
      placeId,
      verifiedAt);

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerificationResultImplCopyWith<_$VerificationResultImpl> get copyWith =>
      __$$VerificationResultImplCopyWithImpl<_$VerificationResultImpl>(
          this, _$identity);
}

abstract class _VerificationResult implements VerificationResult {
  const factory _VerificationResult(
      {required final double finalScore,
      required final bool passed,
      required final bool needsChallenge,
      required final LivenessResult liveness,
      required final SceneMatchResult scene,
      required final SensorFusionResult sensor,
      required final String certificateHash,
      required final String placeId,
      required final DateTime verifiedAt}) = _$VerificationResultImpl;

  @override
  double get finalScore;
  @override
  bool get passed;
  @override
  bool get needsChallenge;
  @override
  LivenessResult get liveness;
  @override
  SceneMatchResult get scene;
  @override
  SensorFusionResult get sensor;
  @override
  String get certificateHash;
  @override
  String get placeId;
  @override
  DateTime get verifiedAt;

  /// Create a copy of VerificationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerificationResultImplCopyWith<_$VerificationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
