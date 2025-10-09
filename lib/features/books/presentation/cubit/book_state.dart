import '../../data/models/book_model.dart';

// Abstract base state
abstract class BookState {}

// Initial state when nothing is loaded yet
class BookInitial extends BookState {}

// State when the list of books is loaded
class BookLoaded extends BookState {
  final List<BookModel> books;
  BookLoaded(this.books);
}
