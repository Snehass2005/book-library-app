import 'package:book_library_app/features/books/data/models/book_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DeleteBook {
  final Box<BookModel> box;

  DeleteBook(this.box);

  Future<void> call(String bookId) async {
    await box.delete(bookId);
  }
}
