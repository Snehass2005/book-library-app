// lib/features/books/book_details/domain/repositories/book_details_repository.dart

import 'package:book_library_app/feature/book_details/data/models/rating_model.dart';
import 'package:book_library_app/feature/book_details/data/models/recommendation_model.dart';
import 'package:book_library_app/feature/book_details/data/models/reveiw_model.dart';
import 'package:book_library_app/shared/models/book_model.dart';


abstract class BookDetailsRepository {
  /// Fetches full book details from the API
  Future<BookModel?> getBookDetails(String bookId);

  /// Fetches all reviews for a book
  Future<List<ReviewModel>> getReviews(String bookId);

  /// Fetches all ratings for a book
  Future<List<RatingModel>> getRatings(String bookId);

  /// Fetches recommended books based on this book
  Future<List<RecommendationModel>> getRecommendations(String bookId);
}