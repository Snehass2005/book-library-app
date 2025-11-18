
import 'package:book_library_app/shared/models/book_model.dart';

abstract class AddBookRepository {
  Future<void> addBook(BookModel book);
}