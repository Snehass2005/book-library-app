import 'package:book_library_app/core/exceptions/exception_handler_mixin.dart';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/main/app_env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';

import 'network_service.dart';

class DioNetworkService extends NetworkService with ExceptionHandlerMixin {
  late final Dio _dio;

  DioNetworkService() {
    _dio = Dio();
    _dio.options = dioBaseOptions;

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          queryParameters: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          showProcessingTime: true,
          showCUrl: true,
          canShowLog: kDebugMode,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) => handler.next(response),
      ),
    );
  }

  BaseOptions get dioBaseOptions => BaseOptions(
    baseUrl: baseUrl,
    headers: headers,
  );

  @override
  String get baseUrl => EnvInfo.baseUrl;

  @override
  Map<String, Object> get headers => {
    'accept': 'application/json',
    'content-type': 'application/json',
  };

  @override
  Map<String, dynamic>? updateHeader(Map<String, dynamic> data) {
    final header = {...data, ...headers};
    _dio.options.headers = header;
    return header;
  }

  @override
  Future<Either<AppException, Response>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      }) {
    return handleException(
          () => _dio.get(endpoint, queryParameters: queryParameters),
      endpoint: endpoint,
    );
  }

  @override
  Future<Either<AppException, Response>> post(
      String endpoint, {
        Map<String, dynamic>? data,
      }) {
    return handleException(
          () => _dio.post(endpoint, data: data),
      endpoint: endpoint,
    );
  }

  @override
  Future<Either<AppException, Response>> put(
      String endpoint, {
        Map<String, dynamic>? data,
      }) {
    return handleException(
          () => _dio.put(endpoint, data: data),
      endpoint: endpoint,
    );
  }

  @override
  Future<Either<AppException, Response>> delete(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
      }) {
    return handleException(
          () => _dio.delete(endpoint, queryParameters: queryParameters),
      endpoint: endpoint,
    );
  }

  Future<Either<AppException, Response>> uploadFile(
      String endpoint,
      FormData formData,
      ) {
    return handleException(
          () => _dio.post(endpoint, data: formData),
      endpoint: endpoint,
    );
  }
}