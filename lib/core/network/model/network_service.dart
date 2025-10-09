abstract class NetworkService {
  Future<dynamic> get(String path);
  Future<dynamic> post(String path, dynamic data);
}
