import 'package:hive_flutter/hive_flutter.dart';
import '../../features/books/data/models/book_model.dart';

class HiveConfig {
  static const String bookBox = "books";

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(BookModelAdapter());
    await Hive.openBox<BookModel>(bookBox);
  }
}
