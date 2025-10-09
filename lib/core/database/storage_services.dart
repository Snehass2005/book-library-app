abstract class StorageService {
  Future<void> save<T>(String boxName, String key, T value);
  Future<T?> get<T>(String boxName, String key);
  Future<void> delete<T>(String boxName, String key);
  Future<List<T>> getAll<T>(String boxName);
}
