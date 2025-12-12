import 'package:hive/hive.dart';


@HiveType(typeId: 1) // unique typeId for this model
class ReadingProgressModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String bookId;

  @HiveField(2)
  final int page;

  @HiveField(3)
  final String? chapter;

  @HiveField(4)
  final double percentage;

  @HiveField(5)
  final DateTime timestamp;

  ReadingProgressModel({
    required this.userId,
    required this.bookId,
    required this.page,
    this.chapter,
    required this.percentage,
    required this.timestamp,
  });

  factory ReadingProgressModel.fromJson(Map<String, dynamic> json) =>
      ReadingProgressModel(
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

  /// ✅ Safe fallback factory
  factory ReadingProgressModel.empty() {
    return ReadingProgressModel(
      userId: '',
      bookId: '',
      page: 0,
      chapter: null,
      percentage: 0.0,
      timestamp: DateTime.now(),
    );
  }
}