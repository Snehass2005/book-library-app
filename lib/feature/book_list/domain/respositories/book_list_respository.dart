import 'package:book_library_app/shared/models/book_model.dart';

abstract class BookListRepository {
  Future<List<BookModel>> fetchBooks();
  Future<List<BookModel>> searchBooks(String query);
  Future<void> deleteBook(String bookId);
}