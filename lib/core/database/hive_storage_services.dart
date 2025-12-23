import 'dart:async';
import 'dart:convert';
import 'package:book_library_app/features/reading_progress/domain/models/reading_progress_model.dart'
    hide ReadingProgressModel;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:book_library_app/core/constants/constants.dart';
import 'package:book_library_app/core/database/storage_services.dart';
import 'package:book_library_app/shared/models/user_data.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/features/reading_progress/data/models/reading_progress_model.dart';

class HiveService implements StorageService {
  Box? box;
  final Completer<Box> initCompleter = Completer<Box>();

  @override
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BookModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ReadingProgressModelAdapter());
    }

    // Open typed boxes
    await Hive.openBox<BookModel>('books');
    await Hive.openBox<ReadingProgressModel>('progress_box');
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

  // --- Books Box ---
  Box<BookModel> get bookBox => Hive.box<BookModel>('books');

  @override
  Future<bool> setBooks(List<BookModel> books) async {
    final box = bookBox;
    await box.clear();
    if (books.isNotEmpty) {
      await box.addAll(books);
    }
    return true;
  }

  @override
  Future<List<BookModel>> getBooks() async {
    return bookBox.values.toList();
  }

  Future<bool> addBook(BookModel book) async {
    try {
      // ✅ Ensure coverUrl is not empty
      if (book.coverUrl.isEmpty || !book.coverUrl.startsWith('http')) {
        book = book.copyWith(
          coverUrl:
          'https://covers.openlibrary.org/b/id/10523338-L.jpg', // fallback image
        );
      }

      await bookBox.add(book);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateBook(BookModel book) async {
    try {
      final values = bookBox.values.toList();
      final index = values.indexWhere((b) => b.id == book.id);

      if (index == -1) return false;

      // ✅ Always update the timestamp when editing
      final updatedBook = book.copyWith(updatedAt: DateTime.now());
      await bookBox.putAt(index, updatedBook);
      return true;
    } catch (e) {
      return false;
    }
  }

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

  Future<BookModel?> getBookById(String id) async {
    try {
      return bookBox.values.firstWhere((book) => book.id == id);
    } catch (_) {
      return null;
    }
  }

  // --- Reading Progress Box ---
  Box<ReadingProgressModel> get progressBox =>
      Hive.box<ReadingProgressModel>('progress_box');

  Future<List<ReadingProgressModel>> getProgress() async {
    return progressBox.values.toList();
  }

  Future<void> setProgress(List<ReadingProgressModel> progressList) async {
    await progressBox.clear();
    if (progressList.isNotEmpty) {
      await progressBox.addAll(progressList);
    }
  }
}

// ✅ Seed sample books WITH category restored
Future<void> seedSampleBooks(HiveService hiveService) async {
  await hiveService.bookBox.clear(); // ✅ force clear every time
  final sampleBooks = [
    BookModel(
      id: '1',
      title: 'Flutter for Beginners',
      author: 'Sneha',
      description: 'Intro to Flutter development',
      coverUrl: 'https://picsum.photos/200/300',
      category: 'Technology',
      createdAt: DateTime.now(),
    ),
    BookModel(
      id: '2',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      description: 'Classic novel',
      coverUrl: 'https://covers.openlibrary.org/b/id/7222246-L.jpg',
      category: 'Fiction',
      createdAt: DateTime.now(),
    ),
    BookModel(
      id: '3',
      title: 'Data Science Handbook',
      author: 'Jake VanderPlas',
      description: 'Guide to data science tools',
      coverUrl: 'https://covers.openlibrary.org/b/id/8231856-L.jpg',
      category: 'Computers',
      createdAt: DateTime.now(),
    ),
    BookModel(
      id: '4',
      title: '1984',
      author: 'George Orwell',
      description: 'Dystopian novel',
      coverUrl: 'https://covers.openlibrary.org/b/id/7222246-M.jpg',
      category: 'Fiction',
      createdAt: DateTime.now(),
    ),
    BookModel(
      id: '5',
      title: 'Learning Dart',
      author: 'Chris Buckett',
      description: 'Master Dart programming language',
      coverUrl: 'https://picsum.photos/200/301',
      category: 'Technology',
      createdAt: DateTime.now(),
    ),
    BookModel(
      id: '6',
      title: 'Introduction to Algorithms',
      author: 'Thomas H. Cormen',
      description: 'Comprehensive algorithms reference',
      coverUrl: 'https://covers.openlibrary.org/b/id/135182-L.jpg',
      category: 'Computers',
      createdAt: DateTime.now(),
    ),
  ];

  for (final book in sampleBooks) {
    await hiveService.addBook(book);
  }

  print('✅ Seeded ${sampleBooks.length} books into Hive');
}