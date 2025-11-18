import 'package:book_library_app/feature/book_search/data/models/search_model.dart';


abstract class BookSearchState {}

class BookSearchInitial extends BookSearchState {}

class BookSearchLoading extends BookSearchState {}

class BookSearchLoaded extends BookSearchState {
  final List<BookSearchModel> books;

  BookSearchLoaded(this.books);

  get results => null;
}

class BookSearchError extends BookSearchState {
  final String message;

  BookSearchError(this.message);
}