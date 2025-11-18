
import 'package:book_library_app/feature/add_book/domain/respositories/add_book_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:hive/hive.dart';

class AddBookRepositoryImpl implements AddBookRepository {
  final Box<BookModel> bookBox;

  AddBookRepositoryImpl(this.bookBox);

  @override
  Future<void> addBook(BookModel book) async {
    await bookBox.add(book);
  }
}