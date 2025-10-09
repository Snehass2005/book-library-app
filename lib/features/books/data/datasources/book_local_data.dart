import 'package:hive/hive.dart';
import '../models/book_model.dart';

class BookLocalDataSource {
  final Box<BookModel> box;
  BookLocalDataSource(this.box);

  Future<List<BookModel>> getAllBooks() async => box.values.toList();

  Future<void> saveBook(BookModel book) async {
    await box.put(book.id, book);
  }

  Future<void> deleteBook(String id) async => await box.delete(id);

  Future<void> toggleFavorite(String id) async {
    final book = box.get(id);
    if (book != null) {
      book.isFavorite = !book.isFavorite;
      await book.save();
    }
  }

  List<BookModel> getFavorites() => box.values.where((b) => b.isFavorite).toList();
}
