import 'package:book_library_app/core/constants/endpoints.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
import 'package:hive/hive.dart';


class BookListDataSource {
  final Box<BookModel> box;
  final NetworkService network;

  BookListDataSource(this.box, this.network);

  /// ✅ Fetch books from local Hive
  Future<List<BookModel>> fetchLocalBooks() async {
    final books = box.values.toList();
    print('Books in Hive: ${books.length}');
    return books;
  }

  /// ✅ Fetch books from remote API
  Future<List<BookModel>> fetchRemoteBooks() async {
    final result = await network.get(ApiEndpoint.books);
    return result.fold(
          (error) {
        print('API error: $error');
        return [];
      },
          (response) {
        final data = response.data;
        print('API response: $data');
        if (data is Map<String, dynamic> && data['items'] is List) {
          final items = data['items'] as List;
          return items.map((e) {
            try {
              return BookModel.fromJson(e);
            } catch (err) {
              print('Parse error: $err');
              return null;
            }
          }).whereType<BookModel>().toList();
        }
        return [];
      },
    );
  }

  /// ✅ Save books to Hive
  Future<void> saveBooksToLocal(List<BookModel> books) async {
    for (var book in books) {
      print('Saving book: ${book.title}');
      await box.put(book.id, book);
    }
  }

  /// ✅ Search books locally
  Future<List<BookModel>> searchBooks(String query) async {
    return box.values
        .where((book) =>
    book.title.toLowerCase().contains(query.toLowerCase()) ||
        book.author.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// ✅ Delete book by ID
  Future<void> deleteBook(String bookId) async {
    await box.delete(bookId);
  }
}