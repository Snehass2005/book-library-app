import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:book_library_app/core/constants/constants.dart';
import 'package:book_library_app/core/database/storage_services.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/shared/models/user_data.dart';

class HiveService implements StorageService {
  Box? box;

  @override
  Future<void> init() async {
    await Hive.initFlutter(); // ✅ Hive init
    Hive.registerAdapter(BookModelAdapter()); // ✅ Register adapter

    await Hive.openBox<BookModel>('books'); // ✅ Open book box
    box = await Hive.openBox('bookLibraryBox'); // ✅ App-wide storage
  }

  @override
  bool get hasInitialized => box != null;

  @override
  Future<Object?> get(String key) async => box?.get(key);

  @override
  Future<void> clear() async => await box?.clear();

  @override
  Future<bool> has(String key) async => box?.containsKey(key) ?? false;

  @override
  Future<bool> remove(String key) async {
    await box?.delete(key);
    return true;
  }

  @override
  Future<bool> set(String key, data) async {
    await box?.put(key, data.toString());
    return true;
  }

  @override
  Future<bool> setUser(UserData data) async {
    await box?.put(userDbKey, jsonEncode(data.toJson()));
    return true;
  }

  @override
  Future<UserData> getUser() async {
    final data = await box?.get(userDbKey);
    return UserData.fromJson(jsonDecode(data));
  }

  @override
  Future<bool> setBooks(List<BookModel> books) async {
    await box?.put(bookDbKey, jsonEncode(books.map((b) => b.toJson()).toList()));
    return true;
  }

  @override
  Future<List<BookModel>> getBooks() async {
    final data = await box?.get(bookDbKey);
    final list = jsonDecode(data) as List;
    return list.map((e) => BookModel.fromJson(e)).toList();
  }
}