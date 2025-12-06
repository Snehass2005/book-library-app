import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/reading_progress/data/models/reading_progress_model.dart';
import 'package:book_library_app/features/reading_progress/domain/respositories/reading_progress_respository.dart';

class ReadingProgressUseCases {
  final ReadingProgressRepository _repository;

  const ReadingProgressUseCases(this._repository);

  /// ✅ Load progress for a given book and user
  Future<Either<AppException, ReadingProgressModel>> getProgress({
    required String bookId,
    required String userId,
  }) async {
    return _repository.getProgress(bookId: bookId, userId: userId);
  }

  /// ✅ Submit updated progress
  Future<Either<AppException, void>> submitProgress({
    required ReadingProgressModel progress,
  }) async {
    return _repository.submitProgress(progress: progress);
  }
}