part of 'add_book_page_cubit.dart';

class AddBookState extends Equatable {
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final BookModel? book;

  const AddBookState({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
    this.book,
  });

  AddBookState copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    BookModel? book,
  }) {
    return AddBookState(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      book: book ?? this.book,
    );
  }

  @override
  List<Object?> get props => [isLoading, isError, errorMessage, book];
}

class AddBookLoaded extends AddBookState {
  const AddBookLoaded() : super();
}

class AddBookLoading extends AddBookState {
  const AddBookLoading() : super(isLoading: true);
}

class AddBookSuccess extends AddBookState {
  const AddBookSuccess(BookModel book) : super(book: book);
}

class AddBookError extends AddBookState {
  const AddBookError(String message)
      : super(errorMessage: message, isError: true);
}