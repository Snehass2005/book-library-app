import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/book_search/data/datasources/book_search_datasource.dart';
import 'package:book_library_app/features/book_search/domain/respositories/book_search_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class BookSearchRepositoryImpl extends BookSearchRepository {
  final BookSearchDataSource _bookSearchDataSource;

  BookSearchRepositoryImpl(this._bookSearchDataSource);

  @override
  Future<Either<AppException, List<BookModel>>> searchBooks({required String query}) async {
    final result = await _bookSearchDataSource.searchBooks(query);

    return result.fold(
          (error) => Left(error),
          (searchModels) {
        final books = searchModels.map((m) => m.toEntity()).toList();
        return Right(books);
      },
    );
  }
}