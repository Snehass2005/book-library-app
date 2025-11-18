
import 'package:book_library_app/feature/add_book/domain/usecases/add_book_usecases.dart';
import 'package:book_library_app/shared/models/book_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';



abstract class AddBookState {}

class AddBookInitial extends AddBookState {}

class AddBookLoading extends AddBookState {}

class AddBookSuccess extends AddBookState {}

class AddBookError extends AddBookState {
  final String message;
  AddBookError(this.message);
}

class AddBookCubit extends Cubit<AddBookState> {
  final AddBookUseCase useCase;

  AddBookCubit(this.useCase) : super(AddBookInitial());

  Future<void> addBook(BookModel book) async {
    emit(AddBookLoading());
    try {
      await useCase.execute(book);
      emit(AddBookSuccess());
    } catch (e) {
      emit(AddBookError('Failed to add book: ${e.toString()}'));
    }
  }
}