
import 'package:book_library_app/feature/add_book/domain/respositories/add_book_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class AddBookUseCase {
  final AddBookRepository repository;

  AddBookUseCase(this.repository);

  Future<void> execute(BookModel book) async {
    await repository.addBook(book);
  }
}