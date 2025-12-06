import 'package:dio/dio.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';

class NetworkServiceImpl implements NetworkService {
  final Dio _dio = Dio();

  // ⚠️ CRITICAL: Replace this with your actual backend URL (e.g., 'http://10.0.2.2:8080')
  static const String _kPrivateBaseUrl = 'http://10.0.2.2:8080';

  NetworkServiceImpl() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  @override
  String get baseUrl => ''; // Unused due to dual-API logic

  // FIX: Resolve Map<String, dynamic> vs Map<String, Object> type mismatch
  @override
  Map<String, Object> get headers {
    return _dio.options.headers.cast<String, Object>();
  }

  // FIX: Implement the abstract method
  @override
  Map<String, dynamic>? updateHeader(Map<String, dynamic> data) {
    _dio.options.headers.addAll(data);
    return _dio.options.headers;
  }

  // Helper method to determine the full URL based on the endpoint format
  String _getFullUrl(String endpoint) {
    // If the endpoint is already a full URL (Google Books), use it directly.
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }

    // Otherwise, assume it's a relative path for the Private API.
    // Ensure no double slashes if the endpoint path starts with one.
    final relativePath = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return '$_kPrivateBaseUrl/$relativePath';
  }

  // Helper to handle successful responses
  Either<AppException, Response> _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return Right(response);
    } else {
      return Left(AppException(
        message: response.statusMessage ?? 'API Request Failed',
        identifier: 'http_status_error',
        statusCode: response.statusCode!,
      ));
    }
  }

  // Helper to handle errors (ensures DioErrors are converted correctly)
  Left<AppException, Response> _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        // Response received, but status is 4xx or 5xx
        return Left(AppException(
          message: error.response?.statusMessage ?? 'Request failed with status code ${error.response?.statusCode}',
          identifier: 'http_error_response',
          statusCode: error.response!.statusCode!,
        ));
      }

      // No response (e.g., network timeout, host lookup failure)
      final message = error.message ?? 'Unknown Dio Error';
      return Left(AppException(
        message: message,
        identifier: 'network_connection_error',
        statusCode: 503,
      ));
    }

    return Left(AppException(
      message: error.toString(),
      identifier: 'network_generic_error',
      statusCode: 500,
    ));
  }

  @override
  Future<Either<AppException, Response>> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final url = _getFullUrl(endpoint);
      final response = await _dio.get(url, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (error) {
      return _handleError(error);
    }
  }

  @override
  Future<Either<AppException, Response>> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final url = _getFullUrl(endpoint);
      final response = await _dio.post(url, data: data);
      return _handleResponse(response);
    } catch (error) {
      return _handleError(error);
    }
  }

  // FIX: Implement the abstract method
  @override
  Future<Either<AppException, Response>> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final url = _getFullUrl(endpoint);
      final response = await _dio.put(url, data: data);
      return _handleResponse(response);
    } catch (error) {
      return _handleError(error);
    }
  }

  @override
  Future<Either<AppException, Response>> delete(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final url = _getFullUrl(endpoint);
      final response = await _dio.delete(url, queryParameters: queryParameters);
      return _handleResponse(response);
    } catch (error) {
      return _handleError(error);
    }
  }
}