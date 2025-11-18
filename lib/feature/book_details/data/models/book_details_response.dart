
import 'package:book_library_app/feature/book_details/data/models/rating_model.dart';
import 'package:book_library_app/feature/book_details/data/models/recommendation_model.dart';
import 'package:book_library_app/feature/book_details/data/models/reveiw_model.dart';
import 'package:book_library_app/shared/models/book_model.dart';

class BookDetailsResponse {
  final BookModel book;
  final List<ReviewModel> reviews;
  final RatingModel rating;
  final List<RecommendationModel> recommendations;

  BookDetailsResponse({
    required this.book,
    required this.reviews,
    required this.rating,
    required this.recommendations,
  });

  factory BookDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BookDetailsResponse(
      book: BookModel.fromJson(json['book']),
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
      rating: RatingModel.fromJson(json['rating']),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => RecommendationModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book.toJson(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'rating': rating.toJson(),
      'recommendations': recommendations.map((e) => e.toJson()).toList(),
    };
  }
}