import 'dart:developer';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

part 'add_book_page_state.dart';

class AddBookCubit extends Cubit<AddBookState> {
  final HiveService _hiveService;

  AddBookCubit()
      : _hiveService = GetIt.instance<HiveService>(),
        super(const AddBookLoaded());

  Future<void> addBook(BookModel book) async {
    final currentState = state;
    if (currentState is AddBookLoaded) {
      emit(currentState.copyWith(isLoading: true));
      log("📤 Adding book '${book.title}' to Hive");

      try {
        final existingBooks = await _hiveService.getBooks();
        existingBooks.add(book);
        await _hiveService.setBooks(existingBooks);

        log("✅ Saved to Hive: ${book.title}, category: '${book.category}'");
        emit(AddBookSuccess(book));
      } catch (e) {
        log("❌ Hive save error: $e");
        emit(currentState.copyWith(
          errorMessage: 'Failed to save book locally',
          isLoading: false,
          isError: true,
        ));
      }
    }
  }

  void resetError() {
    final currentState = state;
    if (currentState is AddBookLoaded) {
      emit(currentState.copyWith(isLoading: false, isError: false));
    }
  }
}