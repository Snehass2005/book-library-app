import 'package:book_library_app/core/constants/endpoints.dart';
import 'package:book_library_app/core/network/model/network_service.dart';

import 'package:book_library_app/core/constants/endpoints.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
import 'package:book_library_app/feature/reading_progress/data/models/reading_progress_model.dart';

abstract class ReadingProgressDataSource {
  Future<ReadingProgressModel> getProgress(String bookId, String userId);
  Future<void> submitProgress(ReadingProgressModel progress);
}

class ReadingProgressDataSourceImpl implements ReadingProgressDataSource {
  final NetworkService network;

  ReadingProgressDataSourceImpl(this.network);

  @override
  Future<ReadingProgressModel> getProgress(String bookId, String userId) async {
    final result = await network.get(ApiEndpoint.getProgress(bookId, userId));
    return result.fold(
          (error) => throw error,
          (response) => ReadingProgressModel.fromJson(response.data),
    );
  }

  @override
  Future<void> submitProgress(ReadingProgressModel progress) async {
    await network.post(
      ApiEndpoint.submitProgress(progress.bookId),
      data: progress.toJson(),
    );
  }
}