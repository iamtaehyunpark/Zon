import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

/// Typed error hierarchy used across all repository methods.
/// All repository methods return Either<AppException, T> via fpdart.
@freezed
class AppException with _$AppException {
  const factory AppException.network({String? message}) = NetworkException;
  const factory AppException.server({required int statusCode, String? message}) = ServerException;
  const factory AppException.auth({String? message}) = AuthException;
  const factory AppException.notFound({String? message}) = NotFoundException;
  const factory AppException.validation({required String field, String? message}) = ValidationException;
  const factory AppException.unknown({String? message}) = UnknownException;
}
