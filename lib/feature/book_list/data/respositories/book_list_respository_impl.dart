import 'package:book_library_app/feature/book_list/data/datasources/book_list_datasource.dart';
import 'package:book_library_app/feature/book_list/domain/respositories/book_list_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class BookListRepositoryImpl implements BookListRepository {
  final BookListDataSource dataSource;

  BookListRepositoryImpl(this.dataSource);

  @override
  Future<List<BookModel>> fetchBooks() async {
    var models = await dataSource.fetchLocalBooks();
    print('Local books: ${models.length}');

    if (models.isEmpty) {
      models = await dataSource.fetchRemoteBooks();
      print('Fetched from API: ${models.length}');
      await dataSource.saveBooksToLocal(models);
    }

    return models.map((model) => model.toEntity()).toList();
  }


  @override
  Future<List<BookModel>> searchBooks(String query) async {
    final models = await dataSource.searchBooks(query);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> deleteBook(String bookId) async {
    await dataSource.deleteBook(bookId);
  }
}