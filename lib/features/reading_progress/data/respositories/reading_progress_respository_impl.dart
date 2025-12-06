import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/reading_progress/data/datasources/reading_progress_datasource.dart';
import 'package:book_library_app/features/reading_progress/data/models/reading_progress_model.dart';
import 'package:book_library_app/features/reading_progress/domain/respositories/reading_progress_respository.dart';

class ReadingProgressRepositoryImpl extends ReadingProgressRepository {
  final ReadingProgressDataSource _dataSource;

  ReadingProgressRepositoryImpl(this._dataSource);

  @override
  Future<Either<AppException, ReadingProgressModel>> getProgress({
    required String bookId,
    required String userId,
  }) {
    return _dataSource.getProgress(bookId: bookId, userId: userId);
  }

  @override
  Future<Either<AppException, void>> submitProgress({
    required ReadingProgressModel progress,
  }) {
    return _dataSource.submitProgress(progress: progress);
  }
}