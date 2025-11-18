import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/feature/book_details/data/datasources/book_details_datasoure.dart';
import 'package:book_library_app/feature/book_details/data/models/rating_model.dart';
import 'package:book_library_app/feature/book_details/data/models/recommendation_model.dart';
import 'package:book_library_app/feature/book_details/data/models/reveiw_model.dart';
import 'package:book_library_app/feature/book_details/domain/respositories/book_details_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class BookDetailsRepositoryImpl implements BookDetailsRepository {
  final BookDetailsDataSource dataSource;

  BookDetailsRepositoryImpl({required this.dataSource});

  @override
  Future<BookModel?> getBookDetails(String bookId) async {
    final result = await dataSource.fetchBookDetails(bookId);
    return result.fold(
          (error) {
        // You can log or handle the error here if needed
        return null;
      },
          (book) => book,
    );
  }

  @override
  Future<List<ReviewModel>> getReviews(String bookId) async {
    final result = await dataSource.fetchReviews(bookId);
    return result.fold(
          (error) => [],
          (reviews) => reviews,
    );
  }

  @override
  Future<List<RatingModel>> getRatings(String bookId) async {
    final result = await dataSource.fetchRatings(bookId);
    return result.fold(
          (error) => [],
          (ratings) => ratings,
    );
  }

  @override
  Future<List<RecommendationModel>> getRecommendations(String bookId) async {
    final result = await dataSource.fetchRecommendations(bookId);
    return result.fold(
          (error) => [],
          (recommendations) => recommendations,
    );
  }
}