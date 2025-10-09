import 'package:dio/dio.dart';
import '../models/book_model.dart';

class BookRemoteDataSource {
  final Dio dio;
  BookRemoteDataSource(this.dio);

  /// Example: fakerapi.it endpoint for books might be:
  /// https://fakerapi.it/api/v1/books?_quantity=10
  Future<List<BookModel>> fetchBooks({int quantity = 10}) async {
    final resp = await dio.get('https://fakerapi.it/api/v1/books', queryParameters: {'_quantity': quantity});
    if (resp.statusCode == 200) {
      final data = resp.data['data'] as List;
      return data.map((j) => BookModel.fromJson(j)).toList();
    }
    throw Exception('Failed to fetch');
  }
}
