import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/shared/models/book_model.dart';

abstract class BookSearchRepository {
  Future<Either<AppException, List<BookModel>>> searchBooks({
    required String query,
  });
}