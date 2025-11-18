import 'package:book_library_app/feature/book_details/data/models/rating_model.dart';
import 'package:book_library_app/feature/book_details/data/models/recommendation_model.dart';
import 'package:book_library_app/feature/book_details/data/models/reveiw_model.dart';
import 'package:equatable/equatable.dart';
import 'package:book_library_app/shared/models/book_model.dart';

abstract class BookDetailsState extends Equatable {
  const BookDetailsState();

  @override
  List<Object?> get props => [];
}

class BookDetailsInitial extends BookDetailsState {}

class BookDetailsLoading extends BookDetailsState {}

class BookDetailsLoaded extends BookDetailsState {
  final BookModel? book;
  final List<ReviewModel> reviews;
  final RatingModel rating;
  final List<RecommendationModel> recommendations;


  const BookDetailsLoaded({required this.book, required this.reviews,required this.rating,  required this.recommendations,

  });

  @override
  List<Object?> get props => [book, reviews];
}

class BookDetailsError extends BookDetailsState {
  final String message;

  const BookDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}