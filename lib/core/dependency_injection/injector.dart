import 'package:book_library_app/features/books/data/datasources/book_local_data.dart';
import 'package:book_library_app/features/books/data/datasources/book_remote_data.dart';
import 'package:book_library_app/features/books/data/respositories/book_respository_impl.dart';
import 'package:book_library_app/features/books/domain/repositories/book_repository.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Remote & Local data sources
  sl.registerLazySingleton<BookRemoteDataSource>(() => BookRemoteDataSource(sl()));
  sl.registerLazySingleton<BookLocalDataSource>(() => BookLocalDataSource(sl()));

  // Repository
  sl.registerLazySingleton<BookRepository>(() => BookRepositoryImpl(
    remote: sl(),
    local: sl(),
  ));
}
