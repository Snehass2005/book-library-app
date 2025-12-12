// lib/features/book_list/presentation/cubit/book_list_cubit.dart
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';

part 'book_list_state.dart';

class BookListCubit extends Cubit<BookListState> {
  final HiveService _hiveService;

  BookListCubit({HiveService? hiveService})
      : _hiveService = hiveService ?? injector<HiveService>(),
        super(BookListInitial());
  Future<void> loadBooks() async {
    emit(BookListLoading());
    try {
      final books = _hiveService.bookBox.values.toList();

      // ✅ Add this loop here to debug each book
      for (final book in books) {
        log('📘 ${book.title} → ${book.coverUrl}');
      }

      log('📦 Hive books loaded: ${books.length}');
      emit(BookListSuccess(books: books));
    } catch (e) {
      log('❌ Load error: $e');
      emit(BookListError(errorMessage: 'Failed to load books', books: []));
    }
  }
  Future<void> refreshBooks() async => loadBooks();

  Future<void> deleteBook(String bookId) async {
    final current = state;
    final currentBooks = current is BookListSuccess ? current.books : <BookModel>[];
    emit(BookListLoading());
    try {
      final updated = currentBooks.where((b) => b.id != bookId).toList();
      await _hiveService.setBooks(updated);
      emit(BookListSuccess(books: updated));
    } catch (e) {
      emit(BookListError(errorMessage: 'Failed to delete book', books: currentBooks));
    }
  }

  Future<void> searchBooks(String query) async {
    emit(BookListLoading());
    try {
      final all = await _hiveService.getBooks();
      final q = query.toLowerCase();
      final filtered = all.where((b) =>
      b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q) ||
          b.category.toLowerCase().contains(q)
      ).toList();
      emit(BookListSuccess(books: filtered));
    } catch (e) {
      emit(BookListError(errorMessage: 'Search failed', books: []));
    }
  }

  void resetError() {
    final current = state;
    if (current is BookListError) {
      emit(BookListSuccess(books: current.books));
    }
  }
}