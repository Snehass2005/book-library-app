import 'package:hive/hive.dart';

part 'book_model.g.dart';

@HiveType(typeId: 0)
class BookModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String coverUrl;

  @HiveField(5)
  final String category;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.category,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final info = json['volumeInfo'] ?? {};
    return BookModel(
      id: json['id'] ?? '',
      title: info['title'] ?? '',
      author: (info['authors'] as List?)?.join(', ') ?? '',
      description: info['description'] ?? '',
      coverUrl: info['imageLinks']?['thumbnail']
          ?? info['imageLinks']?['smallThumbnail']
          ?? '',
      category: (info['categories'] as List?)?.first ?? 'Uncategorized',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'author': author,
    'description': description,
    'coverUrl': coverUrl,
    'category': category,
  };

  /// ✅ Safe fallback factory
  factory BookModel.empty() {
    return BookModel(
      id: '',
      title: 'Unknown',
      author: 'Unknown',
      description: 'No description available',
      coverUrl: '',
      category: 'Uncategorized',
    );
  }

  // Equality based on id so Set/dedup works
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BookModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}