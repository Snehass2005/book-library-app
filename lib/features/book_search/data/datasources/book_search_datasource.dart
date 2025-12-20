import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/features/book_search/data/models/search_model.dart';

abstract class BookSearchDataSource {
  Future<Either<AppException, List<BookSearchModel>>> searchBooks(String query);
}

class BookSearchDataSourceImpl implements BookSearchDataSource {
  final HiveService hiveService;
  BookSearchDataSourceImpl(this.hiveService);

  @override
  Future<Either<AppException, List<BookSearchModel>>> searchBooks(String query) async {
    try {
      final books = await hiveService.getBooks();
      final results = books
          .where((b) =>
      b.title.toLowerCase().contains(query.toLowerCase()) ||
          b.author.toLowerCase().contains(query.toLowerCase()))
          .map((b) => BookSearchModel(
        id: b.id,
        title: b.title,
        author: b.author,
        coverUrl: b.coverUrl,
        description: b.description,
        category: b.category,
        createdAt: b.createdAt,
      ))
          .toList();

      return Right(results);
    } catch (e) {
      return Left(AppException(
        message: 'Failed to search books',
        statusCode: 1,
        identifier: '${e.toString()}\nBookSearchDataSource.searchBooks',
      ));
    }
  }
}