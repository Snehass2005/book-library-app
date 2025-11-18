import 'package:book_library_app/feature/book_search/data/datasources/book_search_datasource.dart';
import 'package:book_library_app/feature/book_search/presentation/cubit/book_search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class BookSearchCubit extends Cubit<BookSearchState> {
  final BookSearchDataSource dataSource;

  BookSearchCubit(this.dataSource) : super(BookSearchInitial());

  void search(String query) async {
    if (query.trim().isEmpty) return;

    emit(BookSearchLoading()); // ✅ Removed unnecessary casting
    try {
      final results = await dataSource.searchBooks(query);
      debugPrint('Search results: ${results.length}');
      emit(BookSearchLoaded(results)); // ✅ Removed unnecessary casting
    } catch (e) {
      debugPrint('Search error: $e');
      emit(BookSearchError('Failed to load search results')); // ✅ Removed unnecessary casting
    }
  }
}