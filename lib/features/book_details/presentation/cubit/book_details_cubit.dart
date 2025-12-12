import 'dart:developer';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/book_details/domain/usecases/book_details_usecases.dart';
import 'package:book_library_app/features/book_details/data/models/rating_model.dart';
import 'package:book_library_app/features/book_details/data/models/recommendation_model.dart';
import 'package:book_library_app/features/book_details/data/models/reveiw_model.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

part 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  final BookUseCases _bookUseCases;
  final HiveService _hiveService;

  bool _cancelled = false;

  BookDetailsCubit(this._bookUseCases)
      : _hiveService = GetIt.instance<HiveService>(),
        super(const BookDetailsInitial());

  bool get _canEmit => !isClosed && !_cancelled;

  Future<void> loadDetails(String bookId) async {
    log("📡 loadDetails called with bookId: $bookId");
    if (!_canEmit) return;

    emit(const BookDetailsLoadingState());

    final bookResult = await _bookUseCases.fetchBookDetails(bookId: bookId);
    log("📡 fetchBookDetails completed");

    if (!_canEmit) return;

    bookResult.fold(
          (error) async {
        log("❌ Book fetch error: ${error.message}");
        if (error.statusCode == 404) {
          final localBook = await _hiveService.getBookById(bookId);
          if (!_canEmit) return;
          if (localBook != null) {
            emit(BookDetailsSuccess(
              book: localBook,
              reviews: const [],
              rating: null,
              recommendations: const [],
            ));
          } else {
            emit(const BookDetailsLoaded(
              isLoading: false,
              isError: true,
              errorMessage: "Book not found on server or locally.",
            ));
          }
        } else {
          if (_canEmit) emit(BookDetailsError(message: error.message));
        }
      },
          (book) async {
        final bookModel = book as BookModel;
        log("✅ Book details fetched: ${bookModel.title}");

        // Parallel extras with proper Right typing
        final reviewsFuture = _bookUseCases
            .fetchReviews(bookId: bookId)
            .timeout(const Duration(seconds: 10), onTimeout: () {
          log("⏰ Reviews timed out");
          return Right<AppException, List<ReviewModel>>([]);
        });

        final ratingsFuture = _bookUseCases
            .fetchRatings(bookId: bookId)
            .timeout(const Duration(seconds: 10), onTimeout: () {
          log("⏰ Ratings timed out");
          return Right<AppException, List<RatingModel>>([]);
        });

        final recommendationsFuture = _bookUseCases
            .fetchRecommendations(bookId: bookId)
            .timeout(const Duration(seconds: 10), onTimeout: () {
          log("⏰ Recommendations timed out");
          return Right<AppException, List<RecommendationModel>>([]);
        });

        final results = await Future.wait([
          reviewsFuture,
          ratingsFuture,
          recommendationsFuture,
        ]);

        if (!_canEmit) return;

        List<ReviewModel> reviews = [];
        RatingModel? rating;
        List<RecommendationModel> recommendations = [];

        results[0].fold(
              (error) => log("⚠️ Reviews failed: ${error.message}"),
              (data) => reviews = data as List<ReviewModel>,
        );

        results[1].fold(
              (error) => log("⚠️ Ratings failed: ${error.message}"),
              (data) {
            final list = data as List<RatingModel>;
            if (list.isNotEmpty) rating = list.first;
          },
        );

        results[2].fold(
              (error) => log("⚠️ Recommendations failed: ${error.message}"),
              (data) => recommendations = data as List<RecommendationModel>,
        );

        // Dummy fallback for testing
        if (reviews.isEmpty) {
          reviews = [ReviewModel(reviewer: "Sneha", comment: "Loved it!", rating: 4.5)];
        }
        if (recommendations.isEmpty) {
          recommendations = [
            RecommendationModel(
              id: "1",
              title: "Sample Book",
              author: "Author X",
              coverImage: "",
              category: "Fiction",
            ),
          ];
        }
        if (rating == null) {
          rating = RatingModel(average: 4.2, count: 120);
        }

        log("🎉 Emitting BookDetailsSuccess with "
            "reviews=${reviews.length}, "
            "rating=${rating?.average}, "
            "recommendations=${recommendations.length}");

        if (_canEmit) {
          emit(BookDetailsSuccess(
            book: bookModel,
            reviews: reviews,
            rating: rating,
            recommendations: recommendations,
          ));
        }
      },
    );
  }

  void resetError() {
    if (!_canEmit) return;
    final currentState = state;
    if (currentState is BookDetailsLoaded) {
      emit(currentState.copyWith(isLoading: false, isError: false));
    } else {
      emit(const BookDetailsLoaded(isLoading: false, isError: false));
    }
  }

  @override
  Future<void> close() {
    log("🛑 BookDetailsCubit closed");
    _cancelled = true;
    return super.close();
  }
}