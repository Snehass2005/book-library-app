import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:dio/dio.dart';

abstract class NetworkService {
  String get baseUrl;
  Map<String, Object> get headers;

  Map<String, dynamic>? updateHeader(Map<String, dynamic> data);

  Future<Either<AppException, Response>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      });

  Future<Either<AppException, Response>> post(
      String endpoint, {
        Map<String, dynamic>? data,
      });

  Future<Either<AppException, Response>> put(
      String endpoint, {
        Map<String, dynamic>? data,
      });

  Future<Either<AppException, Response>> delete(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      });
}
