class ReadingProgressModel {
  final String userId;
  final String bookId;
  final int page;
  final String? chapter;
  final double percentage;
  final DateTime timestamp;

  ReadingProgressModel({
    required this.userId,
    required this.bookId,
    required this.page,
    this.chapter,
    required this.percentage,
    required this.timestamp,
  });

  factory ReadingProgressModel.fromJson(Map<String, dynamic> json) => ReadingProgressModel(
    userId: json['userId'],
    bookId: json['bookId'],
    page: json['page'],
    chapter: json['chapter'],
    percentage: (json['percentage'] as num).toDouble(),
    timestamp: DateTime.parse(json['timestamp']),
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'bookId': bookId,
    'page': page,
    'chapter': chapter,
    'percentage': percentage,
    'timestamp': timestamp.toIso8601String(),
  };
}