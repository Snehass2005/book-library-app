import 'package:book_library_app/core/constants/endpoints.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
import 'package:book_library_app/feature/book_search/data/models/search_model.dart';


abstract class BookSearchDataSource {
  Future<List<BookSearchModel>> searchBooks(String query);
}

class BookSearchDataSourceImpl implements BookSearchDataSource {
  final NetworkService network;

  BookSearchDataSourceImpl(this.network);

  @override
  Future<List<BookSearchModel>> searchBooks(String query) async {
    final result = await network.get(ApiEndpoint.searchBooks(query));

    return result.fold(
          (error) => throw error,
          (response) {
        final items = response.data['items'] as List?;
        if (items == null || items.isEmpty) return [];

        return items.map((e) => BookSearchModel.fromJson(e)).toList();
      },
    );
  }
}