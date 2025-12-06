import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/reading_progress/data/models/reading_progress_model.dart';

abstract class ReadingProgressRepository {
  Future<Either<AppException, ReadingProgressModel>> getProgress({
    required String bookId,
    required String userId,
  });

  Future<Either<AppException, void>> submitProgress({
    required ReadingProgressModel progress,
  });
}