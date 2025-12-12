import 'dart:developer';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/shared/models/book_model.dart';

abstract class BookListDataSource {
  Future<Either<AppException, List<BookModel>>> fetchBooks();
  Future<Either<AppException, List<BookModel>>> searchBooks(String query);
  Future<Either<AppException, void>> deleteBook(String bookId);
}

class BookListDataSourceImpl implements BookListDataSource {
  final HiveService hiveService;

  BookListDataSourceImpl(this.hiveService);

  @override
  Future<Either<AppException, List<BookModel>>> fetchBooks() async {
    try {
      final books = await hiveService.getBooks();
      log("📦 Hive Books fetched: ${books.length}");
      return Right(books);
    } catch (e) {
      return Left(AppException(
        message: 'Failed to load books',
        statusCode: 1,
        identifier: '${e.toString()}\nBookListDataSource.fetchBooks',
      ));
    }
  }

  @override
  Future<Either<AppException, List<BookModel>>> searchBooks(String query) async {
    try {
      final books = await hiveService.getBooks();
      final results = books
          .where((b) =>
      b.title.toLowerCase().contains(query.toLowerCase()) ||
          b.author.toLowerCase().contains(query.toLowerCase()))
          .toList();
      log("📦 Hive Search results: ${results.length}");
      return Right(results);
    } catch (e) {
      return Left(AppException(
        message: 'Failed to search books',
        statusCode: 1,
        identifier: '${e.toString()}\nBookListDataSource.searchBooks',
      ));
    }
  }

  @override
  Future<Either<AppException, void>> deleteBook(String bookId) async {
    try {
      final success = await hiveService.deleteBook(bookId);
      if (success) {
        log("📦 Hive Book deleted: $bookId");
      }
      return const Right(null);
    } catch (e) {
      return Left(AppException(
        message: 'Failed to delete book',
        statusCode: 1,
        identifier: '${e.toString()}\nBookListDataSource.deleteBook',
      ));
    }
  }
}