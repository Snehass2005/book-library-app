import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/shared/models/book_model.dart';

abstract class AddBookRepository {
  Future<Either<AppException, void>> addBook({required BookModel book});
  Future<Either<AppException, void>> updateBook({required BookModel book});
  Future<Either<AppException, void>> deleteBook({required String id});
  Future<Either<AppException, List<BookModel>>> getAllBooks();
}