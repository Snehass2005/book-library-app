

import 'package:book_library_app/shared/models/book_model.dart';

class BookSearchModel {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String description;
  final String category; // ✅ Added for completeness

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
      category: volumeInfo['categories']?.first ?? 'Uncategorized', // ✅ Added
    );
  }

  BookModel toModel() {
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