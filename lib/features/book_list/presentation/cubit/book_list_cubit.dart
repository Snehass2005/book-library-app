import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/features/book_list/domain/usecases/book_list_usecases.dart';
import 'package:book_library_app/shared/models/book_model.dart';

part 'book_list_state.dart';

class BookListCubit extends Cubit<BookListState> {
  final BookListUseCases _bookListUseCases;
  final HiveService _hiveService;

  BookListCubit(this._bookListUseCases)
      : _hiveService = HiveService(),
        super(BookListInitial());

  /// Load books (Hive first, then API)
  Future<void> loadBooks() async {
    emit(BookListLoading());
    try {
      final result = await _bookListUseCases.fetchBooks();
      result.fold(
            (error) => emit(BookListError(errorMessage: error.message, books: [])),
            (books) => emit(BookListSuccess(books: books)),
      );
    } catch (e) {
      emit(BookListError(errorMessage: 'Something went wrong', books: []));
    }
  }

  /// Refresh books from API
  Future<void> refreshBooks() async {
    emit(BookListLoading());
    try {
      final result = await _bookListUseCases.refreshBooksFromApi();
      result.fold(
            (error) => emit(BookListError(errorMessage: error.message, books: [])),
            (books) => emit(BookListSuccess(books: books)),
      );
    } catch (e) {
      emit(BookListError(errorMessage: 'Failed to refresh books', books: []));
    }
  }

  /// Delete a book
  Future<void> deleteBook(String bookId) async {
    final currentState = state;
    List<BookModel> currentBooks = [];
    if (currentState is BookListSuccess) currentBooks = currentState.books;

    emit(BookListLoading());
    final result = await _bookListUseCases.deleteBook(bookId: bookId);
    result.fold(
          (error) => emit(BookListError(errorMessage: error.message, books: currentBooks)),
          (_) async {
        final updatedBooks = currentBooks.where((b) => b.id != bookId).toList();
        emit(BookListSuccess(books: updatedBooks));
      },
    );
  }

  /// Search books
  Future<void> searchBooks(String query) async {
    final currentState = state;
    List<BookModel> currentBooks = [];
    if (currentState is BookListSuccess) currentBooks = currentState.books;

    emit(BookListLoading());
    final result = await _bookListUseCases.searchBooks(query: query);
    result.fold(
          (error) => emit(BookListError(errorMessage: error.message, books: currentBooks)),
          (books) => emit(BookListSuccess(books: books)),
    );
  }

  /// Reset error state
  void resetError() {
    final currentState = state;
    if (currentState is BookListError) {
      emit(BookListSuccess(books: currentState.books));
    }
  }
}
