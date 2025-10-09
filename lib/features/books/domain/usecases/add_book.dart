import 'package:hive/hive.dart';
import '../../data/models/book_model.dart';

class AddBook {
  final Box<BookModel> box;

  AddBook(this.box);

  Future<void> call(BookModel book) async {
    await box.put(book.id, book); // save book in Hive
  }
}
