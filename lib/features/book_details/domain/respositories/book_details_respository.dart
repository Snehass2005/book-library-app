// lib/features/books/book_details/domain/repositories/book_details_repository.dart

import '../../../../core/exceptions/http_exception.dart';
import '../../../../core/network/model/either.dart';
import '../../data/models/rating_model.dart';
import '../../data/models/recommendation_model.dart';
import '../../data/models/reveiw_model.dart';
import '../../../../shared/models/book_model.dart';

abstract class BookDetailsRepository {
  /// Fetches full book details from the API
  Future<Either<AppException, BookModel>> getBookDetails({required String bookId});

  /// Fetches all reviews for a book
  Future<Either<AppException, List<ReviewModel>>> getReviews({required String bookId});

  /// Fetches all ratings for a book
  Future<Either<AppException, List<RatingModel>>> getRatings({required String bookId});

  /// Fetches recommended books based on this book
  Future<Either<AppException, List<RecommendationModel>>> getRecommendations({required String bookId});
}