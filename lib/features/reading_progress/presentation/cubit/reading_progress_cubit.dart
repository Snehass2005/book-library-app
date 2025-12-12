import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/reading_progress/data/models/reading_progress_model.dart';
import 'package:book_library_app/features/reading_progress/domain/usecases/reading_progress_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

part 'reading_progress_state.dart';

class ReadingProgressCubit extends Cubit<ReadingProgressState> {
  final ReadingProgressUseCases _useCases;
  final HiveService _hiveService;

  ReadingProgressCubit(this._useCases)
      : _hiveService = GetIt.instance<HiveService>(),
        super(const ReadingProgressLoaded());

  /// ✅ Load progress for a given book and user
  Future<void> loadProgress(String bookId, String userId) async {
    final currentState = state;
    if (currentState is ReadingProgressLoaded) {
      emit(currentState.copyWith(isLoading: true));
      Either result = await _useCases.getProgress(bookId: bookId, userId: userId);

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
            (progress) {
          emit(ReadingProgressSuccess(progress));
        },
      );
    }
  }

  /// ✅ Submit updated progress
  Future<void> submitProgress(ReadingProgressModel progress) async {
    final currentState = state;
    if (currentState is ReadingProgressLoaded) {
      emit(currentState.copyWith(isLoading: true));
      Either result = await _useCases.submitProgress(progress: progress);

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
            (_) {
          // ✅ Persist progress locally in Hive
          _hiveService.set('${progress.userId}-${progress.bookId}', progress.page);
          emit(ReadingProgressSaved(progress));
        },
      );
    }
  }

  /// ✅ Reset error flags
  void resetError() {
    final currentState = state;
    if (currentState is ReadingProgressLoaded) {
      emit(currentState.copyWith(isLoading: false, isError: false));
    }
  }
}