import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_library_app/feature/book_details/domain/usecases/book_details_usecases.dart';
import 'package:book_library_app/feature/book_details/presentation/cubit/book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  final BookUseCases useCase;

  BookDetailsCubit(this.useCase) : super(BookDetailsInitial());

  Future<void> loadDetails(String bookId) async {
    emit(BookDetailsLoading());
    try {
      final book = await useCase.fetchBookDetails(bookId);
      final reviews = await useCase.fetchReviews(bookId);
      final rating = await useCase.fetchRatings(bookId);
      final recommendations = await useCase.fetchRecommendations(bookId);

      emit(BookDetailsLoaded(
        book: book,
        reviews: reviews,
        rating: rating.first,
        recommendations: recommendations,
      ));
    } catch (e) {
      emit(BookDetailsError(e.toString()));
    }
  }
}