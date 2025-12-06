class ReviewModel {
  final String reviewer;
  final String comment;
  final double rating;

  ReviewModel({
    required this.reviewer,
    required this.comment,
    required this.rating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewer: json['reviewer'] ?? 'Anonymous',
      comment: json['comment'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewer': reviewer,
      'comment': comment,
      'rating': rating,
    };
  }
}