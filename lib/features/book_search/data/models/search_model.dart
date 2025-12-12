import 'package:hive/hive.dart';
import 'package:book_library_app/shared/models/book_model.dart';

part 'search_model.g.dart';

@HiveType(typeId: 2) // unique typeId
class BookSearchModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String coverUrl;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String category;

  BookSearchModel({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.description,
    required this.category,
  });

  factory BookSearchModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    return BookSearchModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'No Title',
      author: (volumeInfo['authors'] as List?)?.join(', ') ?? 'Unknown',
      coverUrl: volumeInfo['imageLinks']?['thumbnail'] ?? '',
      description: volumeInfo['description'] ?? 'No description available',
      category: volumeInfo['categories']?.first ?? 'Uncategorized',
    );
  }

  BookModel toEntity() {
    return BookModel(
      id: id,
      title: title,
      author: author,
      coverUrl: coverUrl,
      description: description,
      category: category,
    );
  }
}