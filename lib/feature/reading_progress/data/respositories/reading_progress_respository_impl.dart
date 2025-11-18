
import 'package:book_library_app/feature/reading_progress/domain/respositories/reading_progress_respository.dart';
import 'package:hive/hive.dart';

class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  final Box progressBox;

  ReadingProgressRepositoryImpl(this.progressBox);

  @override
  Future<int> getProgress(String bookId, String userId) async {
    final key = '$userId-$bookId';
    final value = progressBox.get(key);
    return value is int ? value : 0;
  }
}