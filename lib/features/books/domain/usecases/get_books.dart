import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBooks {
  final BookRepository repo;
  GetBooks(this.repo);

  Future<List<Book>> call() => repo.fetchBooks();
}
