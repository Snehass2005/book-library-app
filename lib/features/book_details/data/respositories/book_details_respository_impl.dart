import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/features/book_details/data/datasources/book_details_datasoure.dart';
import 'package:book_library_app/features/book_details/data/models/rating_model.dart';
import 'package:book_library_app/features/book_details/data/models/recommendation_model.dart';
import 'package:book_library_app/features/book_details/data/models/reveiw_model.dart';
import 'package:book_library_app/features/book_details/domain/respositories/book_details_respository.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class BookDetailsRepositoryImpl extends BookDetailsRepository {
  final BookDetailsDataSource _dataSource;

  BookDetailsRepositoryImpl(this._dataSource);

  @override
  Future<Either<AppException, BookModel>> getBookDetails({required String bookId}) {
    return _dataSource.fetchBookDetails(bookId: bookId);
  }

  @override
  Future<Either<AppException, List<ReviewModel>>> getReviews({required String bookId}) {
    return _dataSource.fetchReviews(bookId: bookId);
  }

  @override
  Future<Either<AppException, List<RatingModel>>> getRatings({required String bookId}) {
    return _dataSource.fetchRatings(bookId: bookId);
  }

  @override
  Future<Either<AppException, List<RecommendationModel>>> getRecommendations({required String bookId}) {
    return _dataSource.fetchRecommendations(bookId: bookId);
  }
}