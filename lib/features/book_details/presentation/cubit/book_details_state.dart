part of 'book_details_cubit.dart';

sealed class BookDetailsState extends Equatable {
  const BookDetailsState();
  @override
  List<Object?> get props => [];
}

final class BookDetailsInitial extends BookDetailsState {
  const BookDetailsInitial();
}

final class BookDetailsLoadingState extends BookDetailsState {
  const BookDetailsLoadingState();
}

class BookDetailsLoaded extends BookDetailsState {
  final bool isLoading;
  final bool isError;
  final String errorMessage;

  const BookDetailsLoaded({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
  });

  BookDetailsLoaded copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
  }) {
    return BookDetailsLoaded(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isError, errorMessage];
}

final class BookDetailsSuccess extends BookDetailsState {
  final BookModel book;
  final List<ReviewModel> reviews;
  final RatingModel? rating;
  final List<RecommendationModel> recommendations;

  const BookDetailsSuccess({
    required this.book,
    required this.reviews,
    required this.rating,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [
    book,
    reviews,
    rating ?? RatingModel(average: 0.0, count: 0),
    recommendations,
  ];
}

class BookDetailsError extends BookDetailsState {
  final String message;
  const BookDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}