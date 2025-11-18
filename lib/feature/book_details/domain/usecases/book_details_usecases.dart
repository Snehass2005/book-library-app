// lib/features/books/book_details/domain/usecases/book_usecases.dart

import 'package:book_library_app/feature/book_details/data/models/rating_model.dart';
import 'package:book_library_app/feature/book_details/data/models/recommendation_model.dart';
import 'package:book_library_app/feature/book_details/data/models/reveiw_model.dart';
import 'package:book_library_app/feature/book_details/domain/respositories/book_details_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class BookUseCases {
  final BookDetailsRepository repository;

  BookUseCases({required this.repository});

  Future<BookModel?> fetchBookDetails(String bookId) async {
    return await repository.getBookDetails(bookId);
  }

  Future<List<ReviewModel>> fetchReviews(String bookId) async {
    return await repository.getReviews(bookId);
  }

  Future<List<RatingModel>> fetchRatings(String bookId) async {
    return await repository.getRatings(bookId);
  }

  Future<List<RecommendationModel>> fetchRecommendations(String bookId) async {
    return await repository.getRecommendations(bookId);
  }
}