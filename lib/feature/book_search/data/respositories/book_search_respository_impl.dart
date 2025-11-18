
import 'package:book_library_app/feature/book_search/domain/respositories/book_search_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:hive/hive.dart';


class BookSearchRepositoryImpl implements BookSearchRepository {
  final Box<BookModel> bookBox;

  BookSearchRepositoryImpl(this.bookBox);

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    final allBooks = bookBox.values.toList();
    return allBooks.where((book) {
      final lowerQuery = query.toLowerCase();
      return book.title.toLowerCase().contains(lowerQuery) ||
          book.author.toLowerCase().contains(lowerQuery) ||
          book.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}