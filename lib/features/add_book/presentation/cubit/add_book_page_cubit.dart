import 'dart:developer';
import 'package:book_library_app/features/add_book/domain/usecases/add_book_usecases.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

part 'add_book_page_state.dart';

class AddBookCubit extends Cubit<AddBookState> {
  final AddBookUseCase _addBookUseCase;
  final HiveService _hiveService;

  AddBookCubit(this._addBookUseCase)
      : _hiveService = GetIt.instance<HiveService>(),
        super(const AddBookLoaded());

  Future<void> addBook(BookModel book) async {
    final currentState = state;
    if (currentState is AddBookLoaded) {
      emit(currentState.copyWith(isLoading: true));
      log("📤 Starting addBook for '${book.title}'");

      try {
        final result = await _addBookUseCase.addBook(book: book);
        log("✅ addBook result: $result");

        result.fold(
              (error) {
            log("❌ addBook failed: ${error.message}");
            emit(currentState.copyWith(
              errorMessage: error.message,
              isLoading: false,
              isError: true,
            ));
          },
              (_) {
            log("🎉 addBook succeeded for '${book.title}'");
            emit(AddBookSuccess(book));
          },
        );
      } catch (e) {
        log("❌ Unexpected error in addBook: $e");
        emit(currentState.copyWith(
          errorMessage: 'Something went wrong. Please try again.',
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
