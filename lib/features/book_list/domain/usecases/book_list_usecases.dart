import 'dart:developer';

import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/book_list/domain/respositories/book_list_respository.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class BookListUseCases {
  final BookListRepository _repository;
  final HiveService _hiveService;

  const BookListUseCases(this._repository, this._hiveService);

  Future<Either<AppException, List<BookModel>>> fetchBooks() async {
    try {
      var books = await _hiveService.getBooks();
      log("📦 Hive books count: ${books.length}");

      if (books.isEmpty) {
        log("🌐 Fetching from API...");
        final result = await _repository.fetchBooks();

        return result.fold(
              (error) {
            log("❌ API fetch failed: ${error.message}");
            return Left(error);
          },
              (booksFromApi) async {
            log("✅ API books fetched: ${booksFromApi.length}");
            await _hiveService.setBooks(booksFromApi);
            log("💾 Saved API books to Hive");
            return Right(booksFromApi);
          },
        );
      }

      return Right(books);
    } catch (e) {
      log("🔥 Exception in fetchBooks: $e");
      return Left(AppException(
        identifier: 'FETCH_BOOKS_ERROR',
        statusCode: 500,
        message: 'Failed to load books',
      ));
    }
  }

  Future<Either<AppException, List<BookModel>>> searchBooks({
    required String query,
  }) async {
    return _repository.searchBooks(query: query);
  }

  Future<Either<AppException, List<BookModel>>> refreshBooksFromApi() async {
    try {
      final result = await _repository.fetchBooks(); // direct API call
      return result.fold(
            (error) => Left(error),
            (booksFromApi) async {
          await _hiveService.setBooks(booksFromApi); // overwrite Hive
          return Right(booksFromApi);
        },
      );
    } catch (e) {
      return Left(AppException(
        identifier: 'REFRESH_BOOKS_ERROR',
        statusCode: 500,
        message: 'Failed to refresh books',
      ));
    }
  }

  Future<Either<AppException, void>> deleteBook({
    required String bookId,
  }) async {
    final result = await _repository.deleteBook(bookId: bookId);
    return result.fold(
          (error) => Left(error),
          (_) async {
        final books = await _hiveService.getBooks();
        final updated = books.where((b) => b.id != bookId).toList();
        await _hiveService.setBooks(updated);
        return Right(null);
      },
    );
  }
}
