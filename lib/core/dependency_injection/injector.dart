import 'package:book_library_app/feature/add_book/data/respositories/add_book_respository_impl.dart';
import 'package:book_library_app/feature/add_book/domain/respositories/add_book_respository.dart';
import 'package:book_library_app/feature/add_book/domain/usecases/add_book_usecases.dart';
import 'package:book_library_app/feature/add_book/presentation/cubit/add_book_page_cubit.dart';
import 'package:book_library_app/feature/book_details/data/datasources/book_details_datasoure.dart';
import 'package:book_library_app/feature/book_details/data/respositories/book_details_respository_impl.dart';
import 'package:book_library_app/feature/book_details/domain/respositories/book_details_respository.dart';
import 'package:book_library_app/feature/book_details/domain/usecases/book_details_usecases.dart';
import 'package:book_library_app/feature/book_list/data/datasources/book_list_datasource.dart';
import 'package:book_library_app/feature/book_list/data/respositories/book_list_respository_impl.dart';
import 'package:book_library_app/feature/book_list/domain/respositories/book_list_respository.dart';
import 'package:book_library_app/feature/book_list/domain/usecases/book_list_usecases.dart';
import 'package:book_library_app/feature/book_search/data/datasources/book_search_datasource.dart';
import 'package:book_library_app/feature/book_search/data/respositories/book_search_respository_impl.dart';
import 'package:book_library_app/feature/book_search/domain/respositories/book_search_respository.dart';
import 'package:book_library_app/feature/book_search/domain/usecases/book_search_usecases.dart';
import 'package:book_library_app/feature/reading_progress/data/datasources/reading_progress_datasource.dart';
import 'package:book_library_app/feature/reading_progress/data/respositories/reading_progress_respository_impl.dart';
import 'package:book_library_app/feature/reading_progress/domain/respositories/reading_progress_respository.dart';
import 'package:book_library_app/feature/reading_progress/domain/usecases/reading_progress_usecases.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

// Core
import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:book_library_app/core/network/model/dio_network_service.dart';
import 'package:book_library_app/core/network/model/network_service.dart';
import 'package:book_library_app/core/network/network_service_impl.dart';

// Models
import 'package:book_library_app/shared/models/book_model.dart';



final injector = GetIt.instance;

Future<void> init(Box<BookModel> bookBox) async {
  injector
  // 🔹 Core Services
    ..registerLazySingleton<HiveService>(() => HiveService())
    ..registerLazySingleton<DioNetworkService>(() => DioNetworkService())
    ..registerLazySingleton<NetworkService>(() => NetworkServiceImpl())

  // 🔹 Data Sources
    ..registerLazySingleton<BookDetailsDataSource>(
            () => BookDetailsDataSourceImpl(injector<NetworkService>()))
    ..registerLazySingleton<BookListDataSource>(
            () => BookListDataSource(bookBox, injector<NetworkService>()))
    ..registerLazySingleton<BookSearchDataSource>(
            () => BookSearchDataSourceImpl(injector<NetworkService>()))
    ..registerLazySingleton<ReadingProgressDataSource>(
            () => ReadingProgressDataSourceImpl(injector<NetworkService>()))

  // 🔹 Repositories
    ..registerLazySingleton<AddBookRepository>(
            () => AddBookRepositoryImpl(bookBox))
    ..registerLazySingleton<BookDetailsRepository>(
            () => BookDetailsRepositoryImpl(dataSource: injector<BookDetailsDataSource>()))
    ..registerLazySingleton<BookListRepository>(
            () => BookListRepositoryImpl(injector<BookListDataSource>()))
    ..registerLazySingleton<BookSearchRepository>(
            () => BookSearchRepositoryImpl(bookBox))
    ..registerLazySingleton<ReadingProgressRepository>(
            () => ReadingProgressRepositoryImpl(bookBox))

  // 🔹 Use Cases (Unified)
    ..registerLazySingleton<AddBookUseCase>(
            () => AddBookUseCase(injector<AddBookRepository>()))
    ..registerLazySingleton<BookUseCases>(
            () => BookUseCases(repository: injector<BookDetailsRepository>()))
    ..registerLazySingleton<BookListUseCases>(
            () => BookListUseCases(repository: injector<BookListRepository>()))
    ..registerLazySingleton<SearchBooksUseCase>(
            () => SearchBooksUseCase(injector<BookSearchRepository>()))
    ..registerLazySingleton<LoadReadingProgressUseCase>(
            () => LoadReadingProgressUseCase(injector<ReadingProgressRepository>()))

  // 🔹 Cubits
    ..registerFactory<AddBookCubit>(
            () => AddBookCubit(injector<AddBookUseCase>()));
}