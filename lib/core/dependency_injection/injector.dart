import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/core/network/model/dio_network_service.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
import 'package:book_library_app/core/network/network_service_impl.dart';

// Add Book
import 'package:book_library_app/features/add_book/data/datasources/book_local_datasources.dart';
import 'package:book_library_app/features/add_book/data/respositories/add_book_respository_impl.dart';
import 'package:book_library_app/features/add_book/domain/respositories/add_book_respository.dart';
import 'package:book_library_app/features/add_book/domain/usecases/add_book_usecases.dart';
import 'package:book_library_app/features/add_book/presentation/cubit/add_book_page_cubit.dart';

// Book Details
import 'package:book_library_app/features/book_details/data/datasources/book_details_datasoure.dart';
import 'package:book_library_app/features/book_details/data/respositories/book_details_respository_impl.dart';
import 'package:book_library_app/features/book_details/domain/respositories/book_details_respository.dart';
import 'package:book_library_app/features/book_details/domain/usecases/book_details_usecases.dart';

// Book List
import 'package:book_library_app/features/book_list/data/datasources/book_list_datasource.dart';
import 'package:book_library_app/features/book_list/data/respositories/book_list_respository_impl.dart';
import 'package:book_library_app/features/book_list/domain/respositories/book_list_respository.dart';
import 'package:book_library_app/features/book_list/domain/usecases/book_list_usecases.dart';

// Book Search
import 'package:book_library_app/features/book_search/data/datasources/book_search_datasource.dart';
import 'package:book_library_app/features/book_search/data/respositories/book_search_respository_impl.dart';
import 'package:book_library_app/features/book_search/domain/respositories/book_search_respository.dart';
import 'package:book_library_app/features/book_search/domain/usecases/book_search_usecases.dart';

// Reading Progress
import 'package:book_library_app/features/reading_progress/data/datasources/reading_progress_datasource.dart';
import 'package:book_library_app/features/reading_progress/data/respositories/reading_progress_respository_impl.dart';
import 'package:book_library_app/features/reading_progress/domain/respositories/reading_progress_respository.dart';
import 'package:book_library_app/features/reading_progress/domain/usecases/reading_progress_usecases.dart';

import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

Future<void> init() async {
  injector
  /// Core Services
    ..registerLazySingleton<NetworkService>(NetworkServiceImpl.new)
    ..registerLazySingleton<DioNetworkService>(DioNetworkService.new)
    ..registerLazySingleton<HiveService>(HiveService.new)

  /// Data Sources
    ..registerLazySingleton<BookLocalDataSource>(
          () => BookLocalDataSourceImpl(injector<HiveService>()),
    )
    ..registerLazySingleton<BookDetailsDataSource>(
          () => BookDetailsDataSourceImpl(injector<NetworkService>()),
    )
    ..registerLazySingleton<BookListDataSource>(
          () => BookListDataSourceImpl(injector<NetworkService>()),
    )
    ..registerLazySingleton<BookSearchDataSource>(
          () => BookSearchDataSourceImpl(injector<NetworkService>()),
    )
    ..registerLazySingleton<ReadingProgressDataSource>(
          () => ReadingProgressDataSourceImpl(injector<NetworkService>()),
    )

  /// Repositories
    ..registerLazySingleton<AddBookRepository>(
          () => AddBookRepositoryImpl(injector<BookLocalDataSource>()),
    )
    ..registerLazySingleton<BookDetailsRepository>(
          () => BookDetailsRepositoryImpl(injector<BookDetailsDataSource>()),
    )
    ..registerLazySingleton<BookListRepository>(
          () => BookListRepositoryImpl(
        injector<BookListDataSource>(),
        injector<HiveService>(),
      ),
    )
    ..registerLazySingleton<BookSearchRepository>(
          () => BookSearchRepositoryImpl(injector<BookSearchDataSource>()),
    )
    ..registerLazySingleton<ReadingProgressRepository>(
          () => ReadingProgressRepositoryImpl(injector<ReadingProgressDataSource>()),
    )

  /// Use Cases
    ..registerLazySingleton<AddBookUseCase>(
          () => AddBookUseCase(injector<AddBookRepository>()),
    )
    ..registerLazySingleton<BookUseCases>(
          () => BookUseCases(injector<BookDetailsRepository>()),
    )
    ..registerLazySingleton<BookListUseCases>(
          () => BookListUseCases(
        injector<BookListRepository>(),
        injector<HiveService>(), // ✅ HiveService goes here, not repository
      ),
    )
    ..registerLazySingleton<SearchBooksUseCase>(
          () => SearchBooksUseCase(injector<BookSearchRepository>()),
    )
    ..registerLazySingleton<ReadingProgressUseCases>(
          () => ReadingProgressUseCases(injector<ReadingProgressRepository>()),
    )

  /// Cubits
    ..registerFactory<AddBookCubit>(
          () => AddBookCubit(injector<AddBookUseCase>()),
    );
}
