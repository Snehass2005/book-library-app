import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';

abstract class BookLocalDataSource {
  Future<Either<AppException, List<BookModel>>> getAllBooks();
  Future<Either<AppException, void>> addBook({required BookModel book});
  Future<Either<AppException, void>> updateBook({required BookModel book});
  Future<Either<AppException, void>> deleteBook({required String id});
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final HiveService hiveService;

  BookLocalDataSourceImpl(this.hiveService);

  @override
  Future<Either<AppException, List<BookModel>>> getAllBooks() async {
    try {
      final books = await hiveService.getBooks();
      return Right(books);
    } catch (e) {
      return Left(
        AppException(
          message: 'Failed to fetch books',
          statusCode: 1,
          identifier: '${e.toString()}\nBookLocalDataSource.getAllBooks',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> addBook({required BookModel book}) async {
    try {
      final ok = await hiveService.addBook(book);
      if (!ok) {
        return Left(AppException(
          message: 'Failed to add book to local storage',
          statusCode: 1,
          identifier: 'BookLocalDataSource.addBook',
        ));
      }
      return const Right(null);
    } catch (e) {
      return Left(
        AppException(
          message: 'Failed to add book',
          statusCode: 1,
          identifier: '${e.toString()}\nBookLocalDataSource.addBook',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> updateBook({required BookModel book}) async {
    try {
      final ok = await hiveService.updateBook(book);
      if (!ok) {
        return Left(AppException(
          message: 'Book not found',
          statusCode: 404,
          identifier: 'BookLocalDataSource.updateBook',
        ));
      }
      return const Right(null);
    } catch (e) {
      return Left(
        AppException(
          message: 'Failed to update book',
          statusCode: 1,
          identifier: '${e.toString()}\nBookLocalDataSource.updateBook',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> deleteBook({required String id}) async {
    try {
      final ok = await hiveService.deleteBook(id);
      if (!ok) {
        return Left(AppException(
          message: 'Book not found',
          statusCode: 404,
          identifier: 'BookLocalDataSource.deleteBook',
        ));
      }
      return const Right(null);
    } catch (e) {
      return Left(
        AppException(
          message: 'Failed to delete book',
          statusCode: 1,
          identifier: '${e.toString()}\nBookLocalDataSource.deleteBook',
        ),
      );
    }
  }
}
