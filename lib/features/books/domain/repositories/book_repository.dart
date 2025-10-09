import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> fetchBooks({int page = 1});
  Future<void> addBook(Book book);
  Future<void> deleteBook(String id);
  Future<List<Book>> searchBooks(String query);
  Future<void> toggleFavorite(String id);
  Future<List<Book>> getLocalFavorites();
}
