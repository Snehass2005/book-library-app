import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/features/book_list/data/datasources/book_list_datasource.dart';
import 'package:book_library_app/features/book_list/domain/respositories/book_list_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class BookListRepositoryImpl implements BookListRepository {
  final BookListDataSource _apiDataSource;
  final HiveService _hiveService;

  BookListRepositoryImpl(this._apiDataSource, this._hiveService);

  @override
  Future<Either<AppException, List<BookModel>>> fetchBooks() async {
    try {
      // 1️⃣ Try loading from Hive first
      var cachedBooks = await _hiveService.getBooks();
      if (cachedBooks.isNotEmpty) return Right(cachedBooks);

      // 2️⃣ If empty, fetch from API
      final result = await _apiDataSource.fetchBooks();
      return await result.fold(
            (error) => Left(error),
            (apiBooks) async {
          await _hiveService.setBooks(apiBooks);
          return Right(apiBooks);
        },
      );
    } catch (e) {
      return Left(AppException(
        identifier: 'FETCH_BOOKS_ERROR',
        statusCode: 500,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<AppException, List<BookModel>>> searchBooks({required String query}) async {
    try {
      // Search API
      final result = await _apiDataSource.searchBooks(query);
      return result.fold(
            (error) => Left(error),
            (apiBooks) => Right(apiBooks),
      );
    } catch (e) {
      return Left(AppException(
        identifier: 'SEARCH_BOOKS_ERROR',
        statusCode: 500,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<AppException, void>> deleteBook({required String bookId}) async {
    try {
      // 1️⃣ Delete from API
      final result = await _apiDataSource.deleteBook(bookId);
      return await result.fold(
            (error) => Left(error),
            (_) async {
          // 2️⃣ Delete from Hive
          final books = await _hiveService.getBooks();
          final updated = books.where((b) => b.id != bookId).toList();
          await _hiveService.setBooks(updated);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(AppException(
        identifier: 'DELETE_BOOK_ERROR',
        statusCode: 500,
        message: e.toString(),
      ));
    }
  }
}
