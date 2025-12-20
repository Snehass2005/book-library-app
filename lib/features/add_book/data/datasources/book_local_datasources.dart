import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';

/// Local datasource for managing books in Hive.
/// Only supports fetching all books and adding a new book.
abstract class BookLocalDataSource {
  Future<Either<AppException, List<BookModel>>> getAllBooks();
  Future<Either<AppException, void>> addBook({required BookModel book});
  Future<Either<AppException, void>> updateBook(BookModel book);
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final HiveService hiveService;

  BookLocalDataSourceImpl(this.hiveService);

  @override
  Future<Either<AppException, List<BookModel>>> getAllBooks() async {
    try {
      final books = await hiveService.getBooks();
      return Right(books);
    } catch (e) {
      return Left(
        AppException(
          message: 'Failed to fetch books',
          statusCode: 1,
          identifier: '${e.toString()}\nBookLocalDataSource.getAllBooks',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> addBook({required BookModel book}) async {
    try {
      // ✅ Ensure coverUrl is valid before saving
      if (book.coverUrl.isEmpty || !book.coverUrl.startsWith('http')) {
        book = BookModel(
          id: book.id,
          title: book.title,
          author: book.author,
          description: book.description,
          coverUrl: 'https://covers.openlibrary.org/b/id/10523338-L.jpg', // fallback image
          category: book.category,
          createdAt: book.createdAt,
          updatedAt: book.updatedAt, // ✅ preserve if exists
        );
      }

      final ok = await hiveService.addBook(book);
      if (!ok) {
        return Left(AppException(
          message: 'Failed to add book to local storage',
          statusCode: 1,
          identifier: 'BookLocalDataSource.addBook',
        ));
      }
      return const Right(null);
    } catch (e) {
      return Left(
        AppException(
          message: 'Failed to add book',
          statusCode: 1,
          identifier: '${e.toString()}\nBookLocalDataSource.addBook',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, void>> updateBook(BookModel book) async {
    try {
      // ✅ Always update the timestamp when editing
      final updatedBook = book.copyWith(updatedAt: DateTime.now());

      final ok = await hiveService.updateBook(updatedBook);
      if (!ok) {
        return Left(AppException(
          message: 'Failed to update book in local storage',
          statusCode: 1,
          identifier: 'BookLocalDataSource.updateBook',
        ));
      }
      return const Right(null);
    } catch (e) {
      return Left(
        AppException(
          message: 'Failed to update book',
          statusCode: 1,
          identifier: '${e.toString()}\nBookLocalDataSource.updateBook',
        ),
      );
    }
  }
}