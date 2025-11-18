
import 'package:book_library_app/shared/models/book_model.dart';

abstract class BookSearchRepository {
  Future<List<BookModel>> searchBooks(String query);
}