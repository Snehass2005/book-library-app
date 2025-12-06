import 'dart:async';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:book_library_app/core/constants/constants.dart';
import 'package:book_library_app/core/database/storage_services.dart';
import 'package:book_library_app/shared/models/user_data.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class HiveService implements StorageService {
  Box? box;
  final Completer<Box> initCompleter = Completer<Box>();

  @override
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapter if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BookModelAdapter());
    }

    // Open typed book box and a generic app box
    await Hive.openBox<BookModel>('books');
    final genericBox = await Hive.openBox('bookLibraryBox');

    initCompleter.complete(genericBox);
  }

  @override
  bool get hasInitialized => initCompleter.isCompleted;

  @override
  Future<Object?> get(String key) async {
    box = await initCompleter.future;
    return box?.get(key);
  }

  @override
  Future<void> clear() async {
    box = await initCompleter.future;
    await box?.put('user', {}.toString());
    await box?.clear();
  }

  @override
  Future<bool> has(String key) async {
    box = await initCompleter.future;
    return box?.containsKey(key) ?? false;
  }

  @override
  Future<bool> remove(String key) async {
    box = await initCompleter.future;
    await box?.delete(key);
    return true;
  }

  @override
  Future<bool> set(String key, data) async {
    box = await initCompleter.future;
    await box?.put(key, data.toString());
    return true;
  }

  @override
  Future<bool> setUser(UserData data) async {
    box = await initCompleter.future;
    await box?.put(userDbKey, jsonEncode(data.toJson()));
    return true;
  }

  @override
  Future<UserData> getUser() async {
    box = await initCompleter.future;
    Object? data = await box?.get(userDbKey);
    final dynamic userJson = jsonDecode(data.toString());
    return UserData.fromJson(userJson);
  }

  // Typed book box accessor
  Box<BookModel> get bookBox => Hive.box<BookModel>('books');

  /// Replace entire book list (intentional replacement)
  @override
  Future<bool> setBooks(List<BookModel> books) async {
    final box = bookBox;
    await box.clear();
    if (books.isNotEmpty) {
      // Add BookModel instances directly
      await box.addAll(books);
    }
    return true;
  }

  /// Return all books
  @override
  Future<List<BookModel>> getBooks() async {
    return bookBox.values.toList();
  }

  /// Add a single book
  Future<bool> addBook(BookModel book) async {
    try {
      await bookBox.add(book);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Update an existing book by id (returns true if updated)
  Future<bool> updateBook(BookModel book) async {
    try {
      final values = bookBox.values.toList();
      final index = values.indexWhere((b) => b.id == book.id);
      if (index == -1) return false;
      await bookBox.putAt(index, book);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Delete a book by id (returns true if deleted)
  Future<bool> deleteBook(String id) async {
    try {
      final values = bookBox.values.toList();
      final index = values.indexWhere((b) => b.id == id);
      if (index == -1) return false;
      await bookBox.deleteAt(index);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Get single book by id
  Future<BookModel?> getBookById(String id) async {
    try {
      return bookBox.values.firstWhere((book) => book.id == id);
    } catch (_) {
      return null;
    }
  }
}
