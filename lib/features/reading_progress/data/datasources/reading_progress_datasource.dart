import 'package:book_library_app/core/constants/endpoints.dart';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
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
  final NetworkService networkService;

  ReadingProgressDataSourceImpl(this.networkService);

  @override
  Future<Either<AppException, ReadingProgressModel>> getProgress({
    required String bookId,
    required String userId,
  }) async {
    try {
      final eitherType =
      await networkService.get(ApiEndpoint.getProgress(bookId, userId));

      return eitherType.fold(
            (exception) => Left(exception),
            (response) {
          final progress =
          ReadingProgressModel.fromJson(response.data as Map<String, dynamic>);
          return Right(progress);
        },
      );
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred',
          statusCode: 1,
          identifier: '${e.toString()}\nReadingProgressDataSource.getProgress',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> submitProgress({
    required ReadingProgressModel progress,
  }) async {
    try {
      final eitherType = await networkService.post(
        ApiEndpoint.submitProgress(progress.bookId),
        data: progress.toJson(),
      );

      return eitherType.fold(
            (exception) => Left(exception),
            (_) => const Right(null),
      );
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred',
          statusCode: 1,
          identifier: '${e.toString()}\nReadingProgressDataSource.submitProgress',
        ),
      );
    }
  }
}