import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/features/book_list/domain/respositories/book_list_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class BookListRepositoryImpl implements BookListRepository {
  final HiveService _hiveService;

  BookListRepositoryImpl(this._hiveService);

  @override
  Future<Either<AppException, List<BookModel>>> fetchBooks() async {
    try {
      final books = await _hiveService.getBooks();
      return Right(books);
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
      final books = await _hiveService.getBooks();
      final results = books.where((b) =>
      b.title.toLowerCase().contains(query.toLowerCase()) ||
          b.author.toLowerCase().contains(query.toLowerCase())
      ).toList();
      return Right(results);
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
      final success = await _hiveService.deleteBook(bookId);
      if (success) return const Right(null);
      return Left(AppException(
        identifier: 'DELETE_BOOK_ERROR',
        statusCode: 404,
        message: 'Book not found',
      ));
    } catch (e) {
      return Left(AppException(
        identifier: 'DELETE_BOOK_ERROR',
        statusCode: 500,
        message: e.toString(),
      ));
    }
  }
}