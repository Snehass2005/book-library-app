class RatingModel {
  final double average;
  final int count;

  RatingModel({
    required this.average,
    required this.count,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'count': count,
    };
  }
}