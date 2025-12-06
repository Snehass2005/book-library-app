class RecommendationModel {
  final String id;
  final String title;
  final String author;
  final String coverImage;
  final String category;

  RecommendationModel({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.category,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      coverImage: json['coverImage'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverImage': coverImage,
      'category': category,
    };
  }
}