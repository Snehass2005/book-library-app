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
  Future<void> loadBooks({BookSortType sortType = BookSortType.alphabetAZ, bool includeDeleted = false}) async {
    emit(BookListLoading());
    try {
      // ✅ Filter deleted books unless includeDeleted is true
      final books = _hiveService.bookBox.values
          .where((b) => includeDeleted || b.isDeleted != true)
          .toList();

      // ✅ Apply sorting
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

  // ✅ Proper Hive delete
  Future<void> deleteBook(String bookId) async {
    final current = state;
    final currentBooks = current is BookListSuccess ? current.books : <BookModel>[];
    emit(BookListLoading());
    try {
      final book = _hiveService.bookBox.get(bookId);
      if (book != null) {
        final updatedBook = book.copyWith(isDeleted: true); // ✅ mark deleted
        await _hiveService.bookBox.put(bookId, updatedBook);
      }
      final updated = _hiveService.bookBox.values.toList();
      emit(BookListSuccess(books: updated));
    } catch (e) {
      emit(BookListError(errorMessage: 'Failed to delete book', books: currentBooks));
    }
  }

  // ✅ Improved search (matches anywhere in title)
  Future<void> searchBooks(String query, {bool includeDeleted = false}) async {
    emit(BookListLoading());
    try {
      final all = await _hiveService.getBooks();
      final q = query.toLowerCase();

      final filtered = all.where((b) {
        final matches = b.title.toLowerCase().contains(q);
        final visible = includeDeleted || b.isDeleted != true;
        return matches && visible;
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