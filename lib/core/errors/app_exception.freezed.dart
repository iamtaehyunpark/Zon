// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppException {
  String? get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) network,
    required TResult Function(int statusCode, String? message) server,
    required TResult Function(String? message) auth,
    required TResult Function(String? message) notFound,
    required TResult Function(String field, String? message) validation,
    required TResult Function(String? message) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? network,
    TResult? Function(int statusCode, String? message)? server,
    TResult? Function(String? message)? auth,
    TResult? Function(String? message)? notFound,
    TResult? Function(String field, String? message)? validation,
    TResult? Function(String? message)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? network,
    TResult Function(int statusCode, String? message)? server,
    TResult Function(String? message)? auth,
    TResult Function(String? message)? notFound,
    TResult Function(String field, String? message)? validation,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkException value) network,
    required TResult Function(ServerException value) server,
    required TResult Function(AuthException value) auth,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(ValidationException value) validation,
    required TResult Function(UnknownException value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkException value)? network,
    TResult? Function(ServerException value)? server,
    TResult? Function(AuthException value)? auth,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(ValidationException value)? validation,
    TResult? Function(UnknownException value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkException value)? network,
    TResult Function(ServerException value)? server,
    TResult Function(AuthException value)? auth,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(ValidationException value)? validation,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppExceptionCopyWith<AppException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppExceptionCopyWith<$Res> {
  factory $AppExceptionCopyWith(
          AppException value, $Res Function(AppException) then) =
      _$AppExceptionCopyWithImpl<$Res, AppException>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class _$AppExceptionCopyWithImpl<$Res, $Val extends AppException>
    implements $AppExceptionCopyWith<$Res> {
  _$AppExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkExceptionImplCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory _$$NetworkExceptionImplCopyWith(_$NetworkExceptionImpl value,
          $Res Function(_$NetworkExceptionImpl) then) =
      __$$NetworkExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$NetworkExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$NetworkExceptionImpl>
    implements _$$NetworkExceptionImplCopyWith<$Res> {
  __$$NetworkExceptionImplCopyWithImpl(_$NetworkExceptionImpl _value,
      $Res Function(_$NetworkExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$NetworkExceptionImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NetworkExceptionImpl implements NetworkException {
  const _$NetworkExceptionImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'AppException.network(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkExceptionImplCopyWith<_$NetworkExceptionImpl> get copyWith =>
      __$$NetworkExceptionImplCopyWithImpl<_$NetworkExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) network,
    required TResult Function(int statusCode, String? message) server,
    required TResult Function(String? message) auth,
    required TResult Function(String? message) notFound,
    required TResult Function(String field, String? message) validation,
    required TResult Function(String? message) unknown,
  }) {
    return network(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? network,
    TResult? Function(int statusCode, String? message)? server,
    TResult? Function(String? message)? auth,
    TResult? Function(String? message)? notFound,
    TResult? Function(String field, String? message)? validation,
    TResult? Function(String? message)? unknown,
  }) {
    return network?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? network,
    TResult Function(int statusCode, String? message)? server,
    TResult Function(String? message)? auth,
    TResult Function(String? message)? notFound,
    TResult Function(String field, String? message)? validation,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkException value) network,
    required TResult Function(ServerException value) server,
    required TResult Function(AuthException value) auth,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(ValidationException value) validation,
    required TResult Function(UnknownException value) unknown,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkException value)? network,
    TResult? Function(ServerException value)? server,
    TResult? Function(AuthException value)? auth,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(ValidationException value)? validation,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkException value)? network,
    TResult Function(ServerException value)? server,
    TResult Function(AuthException value)? auth,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(ValidationException value)? validation,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkException implements AppException {
  const factory NetworkException({final String? message}) =
      _$NetworkExceptionImpl;

  @override
  String? get message;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkExceptionImplCopyWith<_$NetworkExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ServerExceptionImplCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory _$$ServerExceptionImplCopyWith(_$ServerExceptionImpl value,
          $Res Function(_$ServerExceptionImpl) then) =
      __$$ServerExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int statusCode, String? message});
}

/// @nodoc
class __$$ServerExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$ServerExceptionImpl>
    implements _$$ServerExceptionImplCopyWith<$Res> {
  __$$ServerExceptionImplCopyWithImpl(
      _$ServerExceptionImpl _value, $Res Function(_$ServerExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? message = freezed,
  }) {
    return _then(_$ServerExceptionImpl(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ServerExceptionImpl implements ServerException {
  const _$ServerExceptionImpl({required this.statusCode, this.message});

  @override
  final int statusCode;
  @override
  final String? message;

  @override
  String toString() {
    return 'AppException.server(statusCode: $statusCode, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerExceptionImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode, message);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerExceptionImplCopyWith<_$ServerExceptionImpl> get copyWith =>
      __$$ServerExceptionImplCopyWithImpl<_$ServerExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) network,
    required TResult Function(int statusCode, String? message) server,
    required TResult Function(String? message) auth,
    required TResult Function(String? message) notFound,
    required TResult Function(String field, String? message) validation,
    required TResult Function(String? message) unknown,
  }) {
    return server(statusCode, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? network,
    TResult? Function(int statusCode, String? message)? server,
    TResult? Function(String? message)? auth,
    TResult? Function(String? message)? notFound,
    TResult? Function(String field, String? message)? validation,
    TResult? Function(String? message)? unknown,
  }) {
    return server?.call(statusCode, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? network,
    TResult Function(int statusCode, String? message)? server,
    TResult Function(String? message)? auth,
    TResult Function(String? message)? notFound,
    TResult Function(String field, String? message)? validation,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(statusCode, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkException value) network,
    required TResult Function(ServerException value) server,
    required TResult Function(AuthException value) auth,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(ValidationException value) validation,
    required TResult Function(UnknownException value) unknown,
  }) {
    return server(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkException value)? network,
    TResult? Function(ServerException value)? server,
    TResult? Function(AuthException value)? auth,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(ValidationException value)? validation,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return server?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkException value)? network,
    TResult Function(ServerException value)? server,
    TResult Function(AuthException value)? auth,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(ValidationException value)? validation,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(this);
    }
    return orElse();
  }
}

abstract class ServerException implements AppException {
  const factory ServerException(
      {required final int statusCode,
      final String? message}) = _$ServerExceptionImpl;

  int get statusCode;
  @override
  String? get message;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerExceptionImplCopyWith<_$ServerExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthExceptionImplCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory _$$AuthExceptionImplCopyWith(
          _$AuthExceptionImpl value, $Res Function(_$AuthExceptionImpl) then) =
      __$$AuthExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$AuthExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$AuthExceptionImpl>
    implements _$$AuthExceptionImplCopyWith<$Res> {
  __$$AuthExceptionImplCopyWithImpl(
      _$AuthExceptionImpl _value, $Res Function(_$AuthExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$AuthExceptionImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AuthExceptionImpl implements AuthException {
  const _$AuthExceptionImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'AppException.auth(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthExceptionImplCopyWith<_$AuthExceptionImpl> get copyWith =>
      __$$AuthExceptionImplCopyWithImpl<_$AuthExceptionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) network,
    required TResult Function(int statusCode, String? message) server,
    required TResult Function(String? message) auth,
    required TResult Function(String? message) notFound,
    required TResult Function(String field, String? message) validation,
    required TResult Function(String? message) unknown,
  }) {
    return auth(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? network,
    TResult? Function(int statusCode, String? message)? server,
    TResult? Function(String? message)? auth,
    TResult? Function(String? message)? notFound,
    TResult? Function(String field, String? message)? validation,
    TResult? Function(String? message)? unknown,
  }) {
    return auth?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? network,
    TResult Function(int statusCode, String? message)? server,
    TResult Function(String? message)? auth,
    TResult Function(String? message)? notFound,
    TResult Function(String field, String? message)? validation,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkException value) network,
    required TResult Function(ServerException value) server,
    required TResult Function(AuthException value) auth,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(ValidationException value) validation,
    required TResult Function(UnknownException value) unknown,
  }) {
    return auth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkException value)? network,
    TResult? Function(ServerException value)? server,
    TResult? Function(AuthException value)? auth,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(ValidationException value)? validation,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return auth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkException value)? network,
    TResult Function(ServerException value)? server,
    TResult Function(AuthException value)? auth,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(ValidationException value)? validation,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(this);
    }
    return orElse();
  }
}

abstract class AuthException implements AppException {
  const factory AuthException({final String? message}) = _$AuthExceptionImpl;

  @override
  String? get message;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthExceptionImplCopyWith<_$AuthExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotFoundExceptionImplCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory _$$NotFoundExceptionImplCopyWith(_$NotFoundExceptionImpl value,
          $Res Function(_$NotFoundExceptionImpl) then) =
      __$$NotFoundExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$NotFoundExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$NotFoundExceptionImpl>
    implements _$$NotFoundExceptionImplCopyWith<$Res> {
  __$$NotFoundExceptionImplCopyWithImpl(_$NotFoundExceptionImpl _value,
      $Res Function(_$NotFoundExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$NotFoundExceptionImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NotFoundExceptionImpl implements NotFoundException {
  const _$NotFoundExceptionImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'AppException.notFound(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotFoundExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotFoundExceptionImplCopyWith<_$NotFoundExceptionImpl> get copyWith =>
      __$$NotFoundExceptionImplCopyWithImpl<_$NotFoundExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) network,
    required TResult Function(int statusCode, String? message) server,
    required TResult Function(String? message) auth,
    required TResult Function(String? message) notFound,
    required TResult Function(String field, String? message) validation,
    required TResult Function(String? message) unknown,
  }) {
    return notFound(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? network,
    TResult? Function(int statusCode, String? message)? server,
    TResult? Function(String? message)? auth,
    TResult? Function(String? message)? notFound,
    TResult? Function(String field, String? message)? validation,
    TResult? Function(String? message)? unknown,
  }) {
    return notFound?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? network,
    TResult Function(int statusCode, String? message)? server,
    TResult Function(String? message)? auth,
    TResult Function(String? message)? notFound,
    TResult Function(String field, String? message)? validation,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkException value) network,
    required TResult Function(ServerException value) server,
    required TResult Function(AuthException value) auth,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(ValidationException value) validation,
    required TResult Function(UnknownException value) unknown,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkException value)? network,
    TResult? Function(ServerException value)? server,
    TResult? Function(AuthException value)? auth,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(ValidationException value)? validation,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkException value)? network,
    TResult Function(ServerException value)? server,
    TResult Function(AuthException value)? auth,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(ValidationException value)? validation,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class NotFoundException implements AppException {
  const factory NotFoundException({final String? message}) =
      _$NotFoundExceptionImpl;

  @override
  String? get message;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotFoundExceptionImplCopyWith<_$NotFoundExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationExceptionImplCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory _$$ValidationExceptionImplCopyWith(_$ValidationExceptionImpl value,
          $Res Function(_$ValidationExceptionImpl) then) =
      __$$ValidationExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String field, String? message});
}

/// @nodoc
class __$$ValidationExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$ValidationExceptionImpl>
    implements _$$ValidationExceptionImplCopyWith<$Res> {
  __$$ValidationExceptionImplCopyWithImpl(_$ValidationExceptionImpl _value,
      $Res Function(_$ValidationExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? message = freezed,
  }) {
    return _then(_$ValidationExceptionImpl(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ValidationExceptionImpl implements ValidationException {
  const _$ValidationExceptionImpl({required this.field, this.message});

  @override
  final String field;
  @override
  final String? message;

  @override
  String toString() {
    return 'AppException.validation(field: $field, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationExceptionImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field, message);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationExceptionImplCopyWith<_$ValidationExceptionImpl> get copyWith =>
      __$$ValidationExceptionImplCopyWithImpl<_$ValidationExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) network,
    required TResult Function(int statusCode, String? message) server,
    required TResult Function(String? message) auth,
    required TResult Function(String? message) notFound,
    required TResult Function(String field, String? message) validation,
    required TResult Function(String? message) unknown,
  }) {
    return validation(field, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? network,
    TResult? Function(int statusCode, String? message)? server,
    TResult? Function(String? message)? auth,
    TResult? Function(String? message)? notFound,
    TResult? Function(String field, String? message)? validation,
    TResult? Function(String? message)? unknown,
  }) {
    return validation?.call(field, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? network,
    TResult Function(int statusCode, String? message)? server,
    TResult Function(String? message)? auth,
    TResult Function(String? message)? notFound,
    TResult Function(String field, String? message)? validation,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(field, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkException value) network,
    required TResult Function(ServerException value) server,
    required TResult Function(AuthException value) auth,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(ValidationException value) validation,
    required TResult Function(UnknownException value) unknown,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkException value)? network,
    TResult? Function(ServerException value)? server,
    TResult? Function(AuthException value)? auth,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(ValidationException value)? validation,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkException value)? network,
    TResult Function(ServerException value)? server,
    TResult Function(AuthException value)? auth,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(ValidationException value)? validation,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class ValidationException implements AppException {
  const factory ValidationException(
      {required final String field,
      final String? message}) = _$ValidationExceptionImpl;

  String get field;
  @override
  String? get message;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationExceptionImplCopyWith<_$ValidationExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownExceptionImplCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory _$$UnknownExceptionImplCopyWith(_$UnknownExceptionImpl value,
          $Res Function(_$UnknownExceptionImpl) then) =
      __$$UnknownExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$UnknownExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$UnknownExceptionImpl>
    implements _$$UnknownExceptionImplCopyWith<$Res> {
  __$$UnknownExceptionImplCopyWithImpl(_$UnknownExceptionImpl _value,
      $Res Function(_$UnknownExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$UnknownExceptionImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UnknownExceptionImpl implements UnknownException {
  const _$UnknownExceptionImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'AppException.unknown(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownExceptionImplCopyWith<_$UnknownExceptionImpl> get copyWith =>
      __$$UnknownExceptionImplCopyWithImpl<_$UnknownExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) network,
    required TResult Function(int statusCode, String? message) server,
    required TResult Function(String? message) auth,
    required TResult Function(String? message) notFound,
    required TResult Function(String field, String? message) validation,
    required TResult Function(String? message) unknown,
  }) {
    return unknown(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? network,
    TResult? Function(int statusCode, String? message)? server,
    TResult? Function(String? message)? auth,
    TResult? Function(String? message)? notFound,
    TResult? Function(String field, String? message)? validation,
    TResult? Function(String? message)? unknown,
  }) {
    return unknown?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? network,
    TResult Function(int statusCode, String? message)? server,
    TResult Function(String? message)? auth,
    TResult Function(String? message)? notFound,
    TResult Function(String field, String? message)? validation,
    TResult Function(String? message)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkException value) network,
    required TResult Function(ServerException value) server,
    required TResult Function(AuthException value) auth,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(ValidationException value) validation,
    required TResult Function(UnknownException value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkException value)? network,
    TResult? Function(ServerException value)? server,
    TResult? Function(AuthException value)? auth,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(ValidationException value)? validation,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkException value)? network,
    TResult Function(ServerException value)? server,
    TResult Function(AuthException value)? auth,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(ValidationException value)? validation,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownException implements AppException {
  const factory UnknownException({final String? message}) =
      _$UnknownExceptionImpl;

  @override
  String? get message;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownExceptionImplCopyWith<_$UnknownExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
