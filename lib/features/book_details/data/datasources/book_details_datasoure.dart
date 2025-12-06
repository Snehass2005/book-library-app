import 'dart:developer';
import 'package:book_library_app/core/constants/endpoints.dart';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
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
  final NetworkService networkService;

  BookDetailsDataSourceImpl(this.networkService);

  @override
  Future<Either<AppException, BookModel>> fetchBookDetails({required String bookId}) async {
    try {
      final eitherType = await networkService.get(ApiEndpoint.bookDetails(bookId));
      return eitherType.fold(
            (exception) => Left(exception),
            (response) {
          log("📡 BookDetails API raw: ${response.data}");
          return Right(BookModel.fromJson(response.data));
        },
      );
    } catch (e) {
      return Left(AppException(
        message: 'Unknown error occurred',
        statusCode: 1,
        identifier: '${e.toString()}\nBookDetailsDataSource.fetchBookDetails',
      ));
    }
  }

  @override
  Future<Either<AppException, List<ReviewModel>>> fetchReviews({required String bookId}) async {
    try {
      final eitherType = await networkService.get(ApiEndpoint.bookReviews(bookId));
      return eitherType.fold(
            (exception) => Left(exception),
            (response) {
          log("📡 Reviews API raw: ${response.data}");
          final data = response.data;
          if (data is List) {
            return Right(data.map((e) => ReviewModel.fromJson(e)).toList());
          } else if (data is Map && data['reviews'] is List) {
            return Right((data['reviews'] as List).map((e) => ReviewModel.fromJson(e)).toList());
          }
          return const Right([]);
        },
      );
    } catch (e) {
      return Left(AppException(
        message: 'Unknown error occurred',
        statusCode: 1,
        identifier: '${e.toString()}\nBookDetailsDataSource.fetchReviews',
      ));
    }
  }

  @override
  Future<Either<AppException, List<RatingModel>>> fetchRatings({required String bookId}) async {
    try {
      final eitherType = await networkService.get(ApiEndpoint.bookRatings(bookId));
      return eitherType.fold(
            (exception) => Left(exception),
            (response) {
          log("📡 Ratings API raw: ${response.data}");
          final data = response.data;
          if (data is List) {
            return Right(data.map((e) => RatingModel.fromJson(e)).toList());
          } else if (data is Map && data['ratings'] is List) {
            return Right((data['ratings'] as List).map((e) => RatingModel.fromJson(e)).toList());
          }
          return const Right([]);
        },
      );
    } catch (e) {
      return Left(AppException(
        message: 'Unknown error occurred',
        statusCode: 1,
        identifier: '${e.toString()}\nBookDetailsDataSource.fetchRatings',
      ));
    }
  }

  @override
  Future<Either<AppException, List<RecommendationModel>>> fetchRecommendations({required String bookId}) async {
    try {
      final eitherType = await networkService.get(ApiEndpoint.bookRecommendations(bookId));
      return eitherType.fold(
            (exception) => Left(exception),
            (response) {
          log("📡 Recommendations API raw: ${response.data}");
          final data = response.data;
          if (data is List) {
            return Right(data.map((e) => RecommendationModel.fromJson(e)).toList());
          } else if (data is Map && data['recommendations'] is List) {
            return Right((data['recommendations'] as List).map((e) => RecommendationModel.fromJson(e)).toList());
          }
          return const Right([]);
        },
      );
    } catch (e) {
      return Left(AppException(
        message: 'Unknown error occurred',
        statusCode: 1,
        identifier: '${e.toString()}\nBookDetailsDataSource.fetchRecommendations',
      ));
    }
  }
}