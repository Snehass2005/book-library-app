import 'package:book_library_app/features/books/data/models/book_model.dart';
import 'package:book_library_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/books/presentation/cubit/book_cubit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BookModelAdapter());
  final box = await Hive.openBox<BookModel>('booksBox');

  runApp(MyApp(box: box)); // pass box
}

class MyApp extends StatelessWidget {
  final Box<BookModel> box; // receive box here

  MyApp({required this.box, super.key}); // constructor

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookCubit(box)..loadBooks(),
      child: MaterialApp.router(
        title: 'Book Library App',
        routerConfig: AppRoutes.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

