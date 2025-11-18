import 'package:book_library_app/shared/models/book_model.dart';
import 'package:hive/hive.dart';


abstract class BookLocalDataSource {
  Future<List<BookModel>> getAllBooks();
  Future<void> addBook(BookModel book);
  Future<void> updateBook(BookModel book);
  Future<void> deleteBook(String id);
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final Box<BookModel> box;
  BookLocalDataSourceImpl(this.box);

  @override
  Future<void> addBook(BookModel book) async {
    await box.put(book.id, book);
  }

  @override
  Future<void> deleteBook(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<BookModel>> getAllBooks() async {
    return box.values.toList();
  }

  @override
  Future<void> updateBook(BookModel book) async {
    await box.put(book.id, book);
  }
}
