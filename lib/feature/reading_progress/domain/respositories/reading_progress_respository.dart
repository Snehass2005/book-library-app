abstract class ReadingProgressRepository {
  Future<int> getProgress(String bookId, String userId);
}