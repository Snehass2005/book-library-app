import 'dart:developer';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/features/book_details/data/models/rating_model.dart';
import 'package:book_library_app/features/book_details/data/models/recommendation_model.dart';
import 'package:book_library_app/features/book_details/data/models/reveiw_model.dart';
import 'package:book_library_app/shared/models/book_model.dart';

abstract class BookDetailsDataSource {
  Future<Either<AppException, BookModel>> fetchBookDetails({required String bookId});
  Future<Either<AppException, List<ReviewModel>>> fetchReviews({required String bookId});
  Future<Either<AppException, List<RatingModel>>> fetchRatings({required String bookId});
  Future<Either<AppException, List<RecommendationModel>>> fetchRecommendations({required String bookId});
}

class BookDetailsDataSourceImpl implements BookDetailsDataSource {
  final HiveService hiveService;

  BookDetailsDataSourceImpl(this.hiveService);

  @override
  Future<Either<AppException, BookModel>> fetchBookDetails({required String bookId}) async {
    try {
      final books = await hiveService.getBooks();
      final book = books.firstWhere(
            (b) => b.id == bookId,
        orElse: () => BookModel.empty(),
      );
      log("📦 Hive BookDetails loaded: ${book.title}");
      return Right(book);
    } catch (e) {
      return Left(AppException(
        message: 'Failed to load book details',
        statusCode: 1,
        identifier: '${e.toString()}\nBookDetailsDataSource.fetchBookDetails',
      ));
    }
  }

  @override
  Future<Either<AppException, List<ReviewModel>>> fetchReviews({required String bookId}) async {
    try {
      // ✅ If reviews are stored in Hive, fetch them here
      log("📦 Hive Reviews fetched for bookId: $bookId");
      return const Right([]); // empty fallback
    } catch (e) {
      return Left(AppException(
        message: 'Failed to load reviews',
        statusCode: 1,
        identifier: '${e.toString()}\nBookDetailsDataSource.fetchReviews',
      ));
    }
  }

  @override
  Future<Either<AppException, List<RatingModel>>> fetchRatings({required String bookId}) async {
    try {
      // ✅ If ratings are stored in Hive, fetch them here
      log("📦 Hive Ratings fetched for bookId: $bookId");
      return const Right([]); // empty fallback
    } catch (e) {
      return Left(AppException(
        message: 'Failed to load ratings',
        statusCode: 1,
        identifier: '${e.toString()}\nBookDetailsDataSource.fetchRatings',
      ));
    }
  }

  @override
  Future<Either<AppException, List<RecommendationModel>>> fetchRecommendations({required String bookId}) async {
    try {
      // ✅ If recommendations are stored in Hive, fetch them here
      log("📦 Hive Recommendations fetched for bookId: $bookId");
      return const Right([]); // empty fallback
    } catch (e) {
      return Left(AppException(
        message: 'Failed to load recommendations',
        statusCode: 1,
        identifier: '${e.toString()}\nBookDetailsDataSource.fetchRecommendations',
      ));
    }
  }
}