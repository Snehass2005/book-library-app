import 'package:book_library_app/core/constants/endpoints.dart';
import 'package:book_library_app/core/exceptions/http_exception.dart';
import 'package:book_library_app/core/network/model/either.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
import 'package:book_library_app/features/book_search/data/models/search_model.dart';

abstract class BookSearchDataSource {
  Future<Either<AppException, List<BookSearchModel>>> searchBooks(String query);
}

class BookSearchDataSourceImpl implements BookSearchDataSource {
  final NetworkService networkService;

  BookSearchDataSourceImpl(this.networkService);

  @override
  Future<Either<AppException, List<BookSearchModel>>> searchBooks(String query) async {
    try {
      // ✅ Build the Google Books API URL
      final fullUrl = ApiEndpoint.getGoogleBooksUrl(query);
      final eitherType = await networkService.get(fullUrl);

      return eitherType.fold(
            (exception) => Left(exception),
            (response) {
          final data = response.data;

          if (data is Map<String, dynamic> && data['items'] is List) {
            final items = data['items'] as List;

            final searchModels = items.map((e) {
              try {
                return BookSearchModel.fromJson(e as Map<String, dynamic>);
              } catch (_) {
                return null;
              }
            }).whereType<BookSearchModel>().toList();

            return Right(searchModels);
          }
          return const Right([]);
        },
      );
    } catch (e) {
      return Left(AppException(
        message: 'Unknown error occurred during search',
        statusCode: 1,
        identifier: '${e.toString()}\nBookSearchDataSource.searchBooks',
      ));
    }
  }
}