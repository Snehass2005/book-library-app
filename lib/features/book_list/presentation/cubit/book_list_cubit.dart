import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/shared/config/book_sort_type.dart';
import 'package:equatable/equatable.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';

part 'book_list_state.dart';

class BookListCubit extends Cubit<BookListState> {
  final HiveService _hiveService;

  BookListCubit({HiveService? hiveService})
      : _hiveService = hiveService ?? injector<HiveService>(),
        super(BookListInitial()) {
    // ✅ Listen for changes in the Hive box
    _hiveService.bookBox.watch().listen((event) async {
      final books = _hiveService.bookBox.values.toList();
      books.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
      emit(BookListSuccess(books: books));
    });
  }

  Future<void> loadBooks({BookSortType sortType = BookSortType.alphabetAZ}) async {
    emit(BookListLoading());
    try {
      final books = _hiveService.bookBox.values.toList();

      switch (sortType) {
        case BookSortType.alphabetAZ:
          books.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
          break;

        case BookSortType.alphabetZA:
          books.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
          break;

        case BookSortType.createdAt:
          books.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
          break;

        case BookSortType.updatedAt:
          books.sort((a, b) {
            final aTime = a.updatedAt ?? a.createdAt;
            final bTime = b.updatedAt ?? b.createdAt;
            return bTime.compareTo(aTime); // newest edit first
          });
          break;
      }

      emit(BookListSuccess(books: books));
    } catch (e) {
      emit(BookListError(errorMessage: 'Failed to load books', books: []));
    }
  }

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

      // ✅ Match only if the title starts with the query
      final filtered = all.where((b) {
        final titleLower = b.title.toLowerCase();
        return titleLower.startsWith(q);
      }).toList();

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