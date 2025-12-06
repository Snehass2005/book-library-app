import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:book_library_app/core/constants/routes.dart';
import 'package:book_library_app/features/add_book/presentation/pages/add_bookpage.dart';
import 'package:book_library_app/features/book_details/presentation/pages/book_details_page.dart';
import 'package:book_library_app/features/book_list/presentation/pages/book_list_page.dart';
import 'package:book_library_app/features/book_search/presentation/pages/book_search_page.dart';
import 'package:book_library_app/features/reading_progress/presentation/pages/reading_progress_page.dart';
import 'package:book_library_app/shared/models/book_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RoutesName.defaultPath,
  routes: <RouteBase>[
    GoRoute(
      path: RoutesName.defaultPath,
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra as Map<String, dynamic>?;
        final currentUserId = args?['currentUserId'] as String? ?? 'defaultUserId';
        return BookListPage(currentUserId: currentUserId);
      },
    ),
    GoRoute(
      path: RoutesName.addBook,
      builder: (BuildContext context, GoRouterState state) => const AddBookPage(),
    ),
    GoRoute(
      path: RoutesName.search,
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra as Map<String, dynamic>?;
        final currentUserId = args?['currentUserId'] as String? ?? 'defaultUserId';
        return BookSearchPage(currentUserId: currentUserId);
      },
    ),
    GoRoute(
      path: RoutesName.bookDetails,
      builder: (BuildContext context, GoRouterState state) {
        final book = state.extra as BookModel;
        return BookDetailsPage(book: book);
      },
    ),
    GoRoute(
      path: RoutesName.readingProgress,
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra as Map<String, dynamic>;
        final bookId = args['bookId'] as String;
        final userId = args['userId'] as String;
        return ReadingProgressPage(bookId: bookId, userId: userId);
      },
    ),
  ],
);