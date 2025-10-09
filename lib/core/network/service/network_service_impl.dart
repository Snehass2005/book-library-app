import 'package:dio/dio.dart';
import '../model/network_service.dart';
import '../model/dio_network_service.dart';

class NetworkServiceImpl implements NetworkService {
  final DioNetworkService _dioService = DioNetworkService();

  @override
  Future<dynamic> get(String path) async {
    final response = await _dioService.get(path);
    return response.data;
  }

  @override
  Future<dynamic> post(String path, dynamic data) async {
    final response = await _dioService.post(path, data);
    return response.data;
  }
}
