part of 'book_search_cubit.dart';

abstract class BookSearchState extends Equatable {
  const BookSearchState();

  @override
  List<Object?> get props => [];
}

class BookSearchLoaded extends BookSearchState {
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final List<BookModel> books;

  const BookSearchLoaded({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
    this.books = const [],
  });

  BookSearchLoaded copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    List<BookModel>? books,
  }) {
    return BookSearchLoaded(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      books: books ?? this.books,
    );
  }

  @override
  List<Object?> get props => [isLoading, isError, errorMessage, books];
}

class BookSearchSuccess extends BookSearchState {
  final List<BookModel> books;

  const BookSearchSuccess(this.books);

  @override
  List<Object?> get props => [books];
}