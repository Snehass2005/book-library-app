import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/add_book/data/datasources/book_local_datasources.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/features/add_book/domain/respositories/add_book_respository.dart';

class AddBookRepositoryImpl implements AddBookRepository {
  final BookLocalDataSource _bookLocalDataSource;

  AddBookRepositoryImpl(this._bookLocalDataSource);

  @override
  Future<Either<AppException, void>> addBook({required BookModel book}) {
    return _bookLocalDataSource.addBook(book: book);
  }

  @override
  Future<Either<AppException, void>> updateBook({required BookModel book}) {
    return _bookLocalDataSource.updateBook(book: book);
  }

  @override
  Future<Either<AppException, void>> deleteBook({required String id}) {
    return _bookLocalDataSource.deleteBook(id: id);
  }

  @override
  Future<Either<AppException, List<BookModel>>> getAllBooks() {
    return _bookLocalDataSource.getAllBooks();
  }
}
