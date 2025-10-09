import 'package:book_library_app/features/books/data/datasources/book_local_data.dart';
import 'package:book_library_app/features/books/data/datasources/book_remote_data.dart';
import 'package:book_library_app/features/books/data/models/book_model.dart';
import 'package:book_library_app/features/books/domain/entities/book.dart';
import 'package:book_library_app/features/books/domain/entities/book.dart';
import 'package:book_library_app/features/books/domain/repositories/book_repository.dart';


class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remote;
  final BookLocalDataSource local;

  BookRepositoryImpl({required this.remote, required this.local});

  @override
  Future<void> addBook(Book book) async {
    final model = BookModel.fromEntity(book);
    await local.saveBook(model);
  }

  @override
  Future<void> deleteBook(String id) async {
    await local.deleteBook(id);
  }

  @override
  Future<List<Book>> fetchBooks({int page = 1}) async {
    try {
      final remoteModels = await remote.fetchBooks(quantity: 10);
      for (var m in remoteModels) {
        await local.saveBook(m);
      }
      return remoteModels.map((m) => m.toEntity()).toList();
    } catch (_) {
      final localModels = await local.getAllBooks();
      return localModels.map((m) => m.toEntity()).toList();
    }
  }

  @override
  Future<List<Book>> searchBooks(String query) async {
    final all = await local.getAllBooks();
    return all
        .where((b) => b.title.toLowerCase().contains(query.toLowerCase()))
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<void> toggleFavorite(String id) async {
    await local.toggleFavorite(id);
  }

  @override
  Future<List<Book>> getLocalFavorites() async {
    final favs = await Future.value(local.getFavorites()); // wrap sync list
    return favs.map((m) => m.toEntity()).toList();
  }
}
