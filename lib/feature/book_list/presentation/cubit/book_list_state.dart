// lib/features/books/book_list/presentation/cubit/book_list_state.dart


import 'package:book_library_app/shared/models/book_model.dart';

abstract class BookListState {}

class BookListInitial extends BookListState {}

class BookListLoading extends BookListState {}

class BookListLoaded extends BookListState {
  final List<BookModel> books;
  BookListLoaded(this.books);
}

class BookListError extends BookListState {
  final String message;
  BookListError(this.message);
}