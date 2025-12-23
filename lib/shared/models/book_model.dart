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
  final String category;   // ✅ restored category

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.category,   // ✅ required again
    required this.createdAt,
    this.updatedAt,
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
      category: (info['categories'] as List?)?.first ?? 'Uncategorized', // ✅ restored
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'author': author,
    'description': description,
    'coverUrl': coverUrl,
    'category': category,   // ✅ restored
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory BookModel.empty() {
    return BookModel(
      id: '',
      title: 'Unknown',
      author: 'Unknown',
      description: 'No description available',
      coverUrl: '',
      category: 'Uncategorized',   // ✅ restored
      createdAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BookModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverUrl,
    String? category,   // ✅ restored
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      category: category ?? this.category,   // ✅ restored
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}