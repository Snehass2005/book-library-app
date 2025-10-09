import 'package:go_router/go_router.dart';
import 'package:book_library_app/features/books/data/models/book_model.dart';
import 'package:book_library_app/features/books/presentation/pages/home_page.dart';
import 'package:book_library_app/features/books/presentation/pages/add_book_page.dart';
import 'package:book_library_app/features/books/presentation/pages/book_details_page.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(), // remove const if state changes
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => AddBookPage(),
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) {
          final book = state.extra;
          if (book is! BookModel) {
            throw Exception('BookModel not provided for /details route');
          }
          return BookDetailsPage(book: book.toEntity());
        },
      ),
    ],
  );
}
