import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/shared/models/book_model.dart';

/// Domain repository interface for adding and fetching books.
/// Only supports addBook and getAllBooks.
abstract class AddBookRepository {
  Future<Either<AppException, void>> addBook({required BookModel book});
  Future<Either<AppException, List<BookModel>>> getAllBooks();
}