import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/add_book/domain/respositories/add_book_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class AddBookUseCase {
  final AddBookRepository _addBookRepository;

  const AddBookUseCase(this._addBookRepository);

  Future<Either<AppException, void>> addBook({required BookModel book}) async {
    return _addBookRepository.addBook(book: book);
  }

  Future<Either<AppException, void>> updateBook({required BookModel book}) async {
    return _addBookRepository.updateBook(book: book);
  }

  Future<Either<AppException, void>> deleteBook({required String id}) async {
    return _addBookRepository.deleteBook(id: id);
  }

  Future<Either<AppException, List<BookModel>>> getAllBooks() async {
    return _addBookRepository.getAllBooks();
  }
}