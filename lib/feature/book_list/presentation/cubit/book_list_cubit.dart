// lib/features/books/book_list/presentation/cubit/book_list_cubit.dart

import 'package:book_library_app/feature/book_list/domain/usecases/book_list_usecases.dart';
import 'package:book_library_app/feature/book_list/presentation/cubit/book_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_library_app/shared/models/book_model.dart';


class BookListCubit extends Cubit<BookListState> {
  final BookListUseCases useCases;

  BookListCubit(this.useCases) : super(BookListInitial());

  /// ✅ Load all books
  Future<void> loadBooks() async {
    emit(BookListLoading());
    try {
      final books = await useCases.fetchBooks();
      emit(BookListLoaded(books));
    } catch (e) {
      emit(BookListError('Failed to load books: $e'));
    }
  }

  /// ✅ Search books
  Future<void> searchBooks(String query) async {
    emit(BookListLoading());
    try {
      final results = await useCases.searchBooks(query);
      emit(BookListLoaded(results));
    } catch (e) {
      emit(BookListError('Search failed: $e'));
    }
  }

  /// ✅ Delete a book
  Future<void> deleteBook(String bookId) async {
    try {
      await useCases.deleteBook(bookId);
      await loadBooks(); // Refresh list after deletion
    } catch (e) {
      emit(BookListError('Delete failed: $e'));
    }
  }
}