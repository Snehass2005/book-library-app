part of 'book_list_cubit.dart';

abstract class BookListState extends Equatable {
  const BookListState();

  @override
  List<Object?> get props => [];
}

class BookListInitial extends BookListState {}

class BookListLoading extends BookListState {}

class BookListSuccess extends BookListState {
  final List<BookModel> books;

  const BookListSuccess({required this.books});

  @override
  List<Object?> get props => [books];
}

class BookListError extends BookListState {
  final String errorMessage;
  final List<BookModel> books;

  const BookListError({required this.errorMessage, required this.books});

  @override
  List<Object?> get props => [errorMessage, books];
}
