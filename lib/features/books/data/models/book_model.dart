import 'package:hive/hive.dart';
import '../../domain/entities/book.dart';

part 'book_model.g.dart';

@HiveType(typeId: 0)
class BookModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String author;

  @HiveField(3)
  double rating;

  @HiveField(4)
  String? coverUrl;

  @HiveField(5)
  bool isFavorite;

  @HiveField(6)
  String description; // ✅ Added missing field

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.rating,
    required this.description, // ✅ required now
    this.coverUrl,
    this.isFavorite = false,
  });

  factory BookModel.fromEntity(Book b) {
    return BookModel(
      id: b.id,
      title: b.title,
      author: b.author,
      rating: b.rating,
      description: b.description, // ✅ added
      coverUrl: b.coverUrl,
      isFavorite: b.isFavorite,
    );
  }

  Book toEntity() => Book(
    id: id,
    title: title,
    author: author,
    rating: rating,
    description: description, // ✅ added
    coverUrl: coverUrl,
    isFavorite: isFavorite,
  );

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['isbn']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      rating: (json['rating'] != null)
          ? double.tryParse(json['rating'].toString()) ?? 0.0
          : 0.0,
      description: json['description'] ?? "No description available", // ✅ added
      coverUrl: json['image'] ?? json['cover'],
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'author': author,
    'rating': rating,
    'description': description, // ✅ added
    'coverUrl': coverUrl,
    'isFavorite': isFavorite,
  };

  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    double? rating,
    String? description, // ✅ added
    String? coverUrl,
    bool? isFavorite,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      rating: rating ?? this.rating,
      description: description ?? this.description, // ✅ added
      coverUrl: coverUrl ?? this.coverUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
