// lib/features/books/book_list/domain/usecases/book_list_usecases.dart

import 'package:book_library_app/feature/book_list/domain/respositories/book_list_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class BookListUseCases {
  final BookListRepository repository;

  BookListUseCases({required this.repository});

  Future<List<BookModel>> fetchBooks() async {
    return await repository.fetchBooks();
  }

  Future<List<BookModel>> searchBooks(String query) async {
    return await repository.searchBooks(query);
  }

  Future<void> deleteBook(String bookId) async {
    await repository.deleteBook(bookId);
  }
}