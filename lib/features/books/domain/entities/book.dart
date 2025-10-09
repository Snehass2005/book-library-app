import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final double rating;
  final String? coverUrl;
  final String description;
  final bool isFavorite;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.rating,
    required this.description,
    this.coverUrl,
    this.isFavorite = false,
  });

  Book copyWith({bool? isFavorite}) {
    return Book(
      id: id,
      title: title,
      author: author,
      rating: rating,
      description: description, // ✅ must be included
      coverUrl: coverUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }


  @override
  List<Object?> get props => [id, title, author, rating, coverUrl, isFavorite];
}
