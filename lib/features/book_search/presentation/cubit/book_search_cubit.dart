import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/features/book_search/domain/usecases/book_search_usecases.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get_it/get_it.dart';

part 'book_search_state.dart';

class BookSearchCubit extends Cubit<BookSearchState> {
  final SearchBooksUseCase _searchBooksUseCase;
  final HiveService _hiveService;
  final NetworkService _networkService;

  BookSearchCubit(this._searchBooksUseCase)
      : _hiveService = GetIt.instance<HiveService>(),
        _networkService = GetIt.instance<NetworkService>(),
        super(const BookSearchLoaded());

  /// ✅ Perform search
  Future<void> search(String query) async {
    final currentState = state;
    if (query.trim().isEmpty) return;

    if (currentState is BookSearchLoaded) {
      emit(currentState.copyWith(isLoading: true));
      Either result = await _searchBooksUseCase.searchBooks(query: query);

      result.fold(
            (error) {
          if (kDebugMode) {
            print(error.identifier);
          }
          emit(
            currentState.copyWith(
              errorMessage: error.message,
              isLoading: false,
              isError: true,
            ),
          );
        },
            (books) {
          emit(BookSearchSuccess(books));
        },
      );
    }
  }

  /// ✅ Reset error flags
  void resetError() {
    final currentState = state;
    if (currentState is BookSearchLoaded) {
      emit(currentState.copyWith(isLoading: false, isError: false));
    }
  }
}