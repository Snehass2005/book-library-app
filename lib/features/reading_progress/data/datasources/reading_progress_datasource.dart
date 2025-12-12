import 'dart:developer';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/features/reading_progress/data/models/reading_progress_model.dart';

abstract class ReadingProgressDataSource {
  Future<Either<AppException, ReadingProgressModel>> getProgress({
    required String bookId,
    required String userId,
  });

  Future<Either<AppException, void>> submitProgress({
    required ReadingProgressModel progress,
  });
}

class ReadingProgressDataSourceImpl implements ReadingProgressDataSource {
  final HiveService hiveService;

  ReadingProgressDataSourceImpl(this.hiveService);

  @override
  Future<Either<AppException, ReadingProgressModel>> getProgress({
    required String bookId,
    required String userId,
  }) async {
    try {
      final progressList = await hiveService.getProgress();
      final progress = progressList.firstWhere(
            (p) => p.bookId == bookId && p.userId == userId,
        orElse: () => ReadingProgressModel.empty(), // ✅ safe fallback
      );
      log("📦 Hive Progress loaded for bookId=$bookId, userId=$userId");
      return Right(progress);
    } catch (e) {
      return Left(AppException(
        message: 'Failed to load progress',
        statusCode: 1,
        identifier: '${e.toString()}\nReadingProgressDataSource.getProgress',
      ));
    }
  }

  @override
  Future<Either<AppException, void>> submitProgress({
    required ReadingProgressModel progress,
  }) async {
    try {
      final progressList = await hiveService.getProgress();
      // Replace existing entry if found
      progressList.removeWhere(
              (p) => p.bookId == progress.bookId && p.userId == progress.userId);
      progressList.add(progress);
      await hiveService.setProgress(progressList);

      log("📦 Hive Progress saved for bookId=${progress.bookId}, userId=${progress.userId}");
      return const Right(null);
    } catch (e) {
      return Left(AppException(
        message: 'Failed to save progress',
        statusCode: 1,
        identifier: '${e.toString()}\nReadingProgressDataSource.submitProgress',
      ));
    }
  }
}