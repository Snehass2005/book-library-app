import 'package:equatable/equatable.dart';

abstract class AddBookState extends Equatable {
  const AddBookState();

  @override
  List<Object?> get props => [];
}

class AddBookInitial extends AddBookState {}

class AddBookLoading extends AddBookState {}

class AddBookSuccess extends AddBookState {}

class AddBookError extends AddBookState {
  final String message;

  const AddBookError(this.message);

  @override
  List<Object?> get props => [message];
}