import 'package:book_library_app/core/network/model/either.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class AppException implements Exception {
  final String message;
  final int statusCode;
  final String identifier;

  AppException({
    required this.message,
    required this.statusCode,
    required this.identifier,
  });

  @override
  String toString() {
    return 'statusCode=$statusCode\nmessage=$message\nidentifier=$identifier';
  }
}

class CacheFailureException extends AppException with EquatableMixin {
  CacheFailureException()
      : super(
    message: 'Unable to save book data',
    statusCode: 100,
    identifier: 'Cache failure exception',
  );

  @override
  List<Object?> get props => [message, statusCode, identifier];
}

extension HttpExceptionExtension on AppException {
  Left<AppException, Response> get toLeft => Left<AppException, Response>(this);
}
