// lib/features/books/book_details/domain/usecases/book_usecases.dart

import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/book_details/data/models/rating_model.dart';
import 'package:book_library_app/features/book_details/data/models/recommendation_model.dart';
import 'package:book_library_app/features/book_details/data/models/reveiw_model.dart';
import 'package:book_library_app/features/book_details/domain/respositories/book_details_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class BookUseCases {
  final BookDetailsRepository _repository;

  const BookUseCases(this._repository);

  Future<Either<AppException, BookModel>> fetchBookDetails({
    required String bookId,
  }) async {
    return _repository.getBookDetails(bookId: bookId);
  }

  Future<Either<AppException, List<ReviewModel>>> fetchReviews({
    required String bookId,
  }) async {
    return _repository.getReviews(bookId: bookId);
  }

  Future<Either<AppException, List<RatingModel>>> fetchRatings({
    required String bookId,
  }) async {
    return _repository.getRatings(bookId: bookId);
  }

  Future<Either<AppException, List<RecommendationModel>>> fetchRecommendations({
    required String bookId,
  }) async {
    return _repository.getRecommendations(bookId: bookId);
  }
}