class ReadingProgressModel {
  final String bookId;
  final String userId;
  final int page;
  final double percentage;
  final DateTime timestamp;

  ReadingProgressModel({
    required this.bookId,
    required this.userId,
    required this.page,
    required this.percentage,
    required this.timestamp,
  });

  factory ReadingProgressModel.fromJson(Map<String, dynamic> json) {
    return ReadingProgressModel(
      bookId: json['bookId'] ?? '',
      userId: json['userId'] ?? '',
      page: json['page'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'userId': userId,
      'page': page,
      'percentage': percentage,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}