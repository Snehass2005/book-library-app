import 'package:dio/dio.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';

class NetworkServiceImpl implements NetworkService {
  final Dio _dio = Dio();

  @override
  String get baseUrl => 'https://www.googleapis.com'; // ✅ Correct for Google Books

  @override
  Map<String, Object> get headers => {
    'Content-Type': 'application/json',
  };

  @override
  Map<String, dynamic>? updateHeader(Map<String, dynamic> data) {
    _dio.options.headers.addAll(data);
    return _dio.options.headers;
  }

  @override
  Future<Either<AppException, Response>> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get('$baseUrl$endpoint', queryParameters: queryParameters);
      return Right(response);
    } catch (error) {
      return Left(AppException(
        message: error.toString(),
        identifier: 'network_error',
        statusCode: 500, // or use response.statusCode if available
      ));
    }
  }

  @override
  Future<Either<AppException, Response>> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.post('$baseUrl$endpoint', data: data);
      return Right(response);
    } catch (error) {
      return Left(AppException(
        message: error.toString(),
        identifier: 'network_error',
        statusCode: 500, // or use response.statusCode if available
      ));
    }
  }

  @override
  Future<Either<AppException, Response>> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put('$baseUrl$endpoint', data: data);
      return Right(response);
    } catch (error) {
      return Left(AppException(
        message: error.toString(),
        identifier: 'network_error',
        statusCode: 500, // or use response.statusCode if available
      ));
    }
  }

  @override
  Future<Either<AppException, Response>> delete(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete('$baseUrl$endpoint', queryParameters: queryParameters);
      return Right(response);
    } catch (error) {
      return Left(AppException(
        message: error.toString(),
        identifier: 'network_error',
        statusCode: 500, // or use response.statusCode if available
      ));
    }
  }
}