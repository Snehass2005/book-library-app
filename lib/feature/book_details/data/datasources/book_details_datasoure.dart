import 'package:book_library_app/core/constants/endpoints.dart';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
import 'package:book_library_app/feature/book_details/data/models/rating_model.dart';
import 'package:book_library_app/feature/book_details/data/models/recommendation_model.dart';
import 'package:book_library_app/feature/book_details/data/models/reveiw_model.dart';
import 'package:book_library_app/shared/models/book_model.dart';

abstract class BookDetailsDataSource {
  Future<Either<AppException, BookModel>> fetchBookDetails(String bookId);
  Future<Either<AppException, List<ReviewModel>>> fetchReviews(String bookId);
  Future<Either<AppException, List<RatingModel>>> fetchRatings(String bookId);
  Future<Either<AppException, List<RecommendationModel>>> fetchRecommendations(String bookId);
}

class BookDetailsDataSourceImpl implements BookDetailsDataSource {
  final NetworkService network;

  BookDetailsDataSourceImpl(this.network);

  @override
  Future<Either<AppException, BookModel>> fetchBookDetails(String bookId) async {
    try {
      final result = await network.get(ApiEndpoint.bookDetails(bookId));
      return result.fold(
            (error) => Left(error),
            (res) => Right(BookModel.fromJson(res.data)),
      );
    } catch (e) {
      return Left(AppException(
        message: 'Failed to fetch book details',
        statusCode: 1,
        identifier: e.toString(),
      ));
    }
  }

  @override
  Future<Either<AppException, List<ReviewModel>>> fetchReviews(String bookId) async {
    try {
      final result = await network.get(ApiEndpoint.bookReviews(bookId));
      return result.fold(
            (error) => Left(error),
            (res) {
          final data = res.data;
          if (data is List) {
            return Right(data.map((e) => ReviewModel.fromJson(e)).toList());
          }
          return const Right([]);
        },
      );
    } catch (e) {
      return Left(AppException(
        message: 'Failed to fetch reviews',
        statusCode: 1,
        identifier: e.toString(),
      ));
    }
  }

  @override
  Future<Either<AppException, List<RatingModel>>> fetchRatings(String bookId) async {
    try {
      final result = await network.get(ApiEndpoint.bookRatings(bookId));
      return result.fold(
            (error) => Left(error),
            (res) {
          final data = res.data;
          if (data is List) {
            return Right(data.map((e) => RatingModel.fromJson(e)).toList());
          }
          return const Right([]);
        },
      );
    } catch (e) {
      return Left(AppException(
        message: 'Failed to fetch ratings',
        statusCode: 1,
        identifier: e.toString(),
      ));
    }
  }

  @override
  Future<Either<AppException, List<RecommendationModel>>> fetchRecommendations(String bookId) async {
    try {
      final result = await network.get(ApiEndpoint.bookRecommendations(bookId));
      return result.fold(
            (error) => Left(error),
            (res) {
          final data = res.data;
          if (data is List) {
            return Right(data.map((e) => RecommendationModel.fromJson(e)).toList());
          }
          return const Right([]);
        },
      );
    } catch (e) {
      return Left(AppException(
        message: 'Failed to fetch recommendations',
        statusCode: 1,
        identifier: e.toString(),
      ));
    }
  }
}