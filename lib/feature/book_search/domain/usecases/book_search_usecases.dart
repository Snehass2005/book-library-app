
import 'package:book_library_app/feature/book_search/domain/respositories/book_search_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';


class SearchBooksUseCase {
  final BookSearchRepository repository;

  SearchBooksUseCase(this.repository);

  Future<List<BookModel>> execute(String query) async {
    return await repository.searchBooks(query);
  }
}