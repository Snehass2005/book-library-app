import 'dart:developer';

import 'package:book_library_app/core/constants/endpoints.dart';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
import 'package:book_library_app/shared/models/book_model.dart';

abstract class BookListDataSource {
  Future<Either<AppException, List<BookModel>>> fetchBooks();
  Future<Either<AppException, List<BookModel>>> searchBooks(String query);
  Future<Either<AppException, void>> deleteBook(String bookId);
}

class BookListDataSourceImpl implements BookListDataSource {
  final NetworkService networkService;

  BookListDataSourceImpl(this.networkService);

  @override
  Future<Either<AppException, List<BookModel>>> fetchBooks() async {
    try {
      // Use a query that always returns results
      final fullUrl = ApiEndpoint.searchBooks("flutter");
      final eitherType = await networkService.get(fullUrl);

      return eitherType.fold(
            (exception) => Left(exception),
            (response) {
          final data = response.data;
          if (data is Map<String, dynamic> && data['items'] is List) {
            final items = data['items'] as List;
            final books = items.map((e) {
              try {
                return BookModel.fromJson(e);
              } catch (_) {
                return null;
              }
            }).whereType<BookModel>().toList();

            return Right(books);
          }
          return const Right([]);
        },
      );
    } catch (e) {
      return Left(AppException(
        message: 'Unknown error occurred',
        statusCode: 1,
        identifier: '${e.toString()}\nBookListDataSource.fetchBooks',
      ));
    }
  }
  @override
  Future<Either<AppException, List<BookModel>>> searchBooks(String query) async {
    try {
      // ✅ Use the correct Google Books search endpoint
      final fullUrl = ApiEndpoint.searchBooks(query);

      final eitherType = await networkService.get(fullUrl);

      return eitherType.fold(
            (exception) => Left(exception),
            (response) {
          final data = response.data;
          log("📡 API response: ${data.toString()}");

          if (data is Map<String, dynamic> && data['items'] is List) {
            final items = data['items'] as List;
            final books = items.map((e) {
              try {
                return BookModel.fromJson(e);
              } catch (_) {
                return null;
              }
            }).whereType<BookModel>().toList();
            log("📚 Parsed books count: ${books.length}");

            return Right(books);
          }
          return const Right([]);
        },
      );
    } catch (e) {
      return Left(AppException(
        message: 'Unknown error occurred',
        statusCode: 1,
        identifier: '${e.toString()}\nBookListDataSource.searchBooks',
      ));
    }
  }

  @override
  Future<Either<AppException, void>> deleteBook(String bookId) async {
    try {
      // ✅ Use the relative path for your private/local API
      final relativePath = ApiEndpoint.deleteBook;

      final eitherType = await networkService.delete(relativePath);

      return eitherType.fold(
            (exception) => Left(exception),
            (_) => const Right(null),
      );
    } catch (e) {
      return Left(AppException(
        message: 'Unknown error occurred',
        statusCode: 1,
        identifier: '${e.toString()}\nBookListDataSource.deleteBook',
      ));
    }
  }
}