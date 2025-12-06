import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/book_search/domain/respositories/book_search_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class SearchBooksUseCase {
  final BookSearchRepository _repository;

  const SearchBooksUseCase(this._repository);

  Future<Either<AppException, List<BookModel>>> searchBooks({
    required String query,
  }) async {
    return _repository.searchBooks(query: query);
  }
}