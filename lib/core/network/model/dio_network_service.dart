import 'package:book_library_app/core/constants/constants.dart';
import 'package:dio/dio.dart';
import '../../exceptions/http_exception.dart';

class DioNetworkService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: Duration(milliseconds: AppConstants.apiTimeout),
    receiveTimeout: Duration(milliseconds: AppConstants.apiTimeout),
  ));

  Future<Response> get(String path) async {
    try {
      return await _dio.get(path);
    } on DioException catch (e) {
      throw HttpException(
        e.message ?? e.response?.statusMessage ?? "Network error",
        code: e.response?.statusCode,
      );
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw HttpException(
        e.message ?? e.response?.statusMessage ?? "Network error",
        code: e.response?.statusCode,
      );
    }
  }
}
