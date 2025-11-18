import 'package:book_library_app/feature/reading_progress/domain/respositories/reading_progress_respository.dart';

class LoadReadingProgressUseCase {
  final ReadingProgressRepository repository;

  LoadReadingProgressUseCase(this.repository);

  Future<int> execute(String bookId, String userId) async {
    return await repository.getProgress(bookId, userId);
  }
}