import 'package:book_library_app/features/books/presentation/cubit/book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:book_library_app/features/books/data/models/book_model.dart';

class BookCubit extends Cubit<BookState> {
  final Box<BookModel> box;

  BookCubit(this.box) : super(BookInitial()) {
    loadBooks();
  }

  void loadBooks() {
    emit(BookLoaded(box.values.toList()));
  }

  Future<void> addBook(BookModel book) async {
    await box.put(book.id, book);
    loadBooks(); // important! emit new state
  }

  Future<void> deleteBook(String id) async {
    await box.delete(id);
    loadBooks();
  }

  void toggleFavorite(String id) {
    final book = box.get(id);
    if (book != null) {
      book.isFavorite = !book.isFavorite;
      book.save();
      loadBooks();
    }
  }
}
