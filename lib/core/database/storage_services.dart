import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/shared/models/user_data.dart';

abstract class StorageService {
  Future<void> init();

  bool get hasInitialized;

  Future<Object?> get(String key);
  Future<bool> set(String key, dynamic data);
  Future<bool> has(String key);
  Future<bool> remove(String key);
  Future<void> clear();

  Future<bool> setUser(UserData data);
  Future<UserData> getUser();

  Future<bool> setBooks(List<BookModel> books);
  Future<List<BookModel>> getBooks();
}