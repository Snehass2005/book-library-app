import 'package:book_library_app/feature/add_book/presentation/pages/add_bookpage.dart';
import 'package:book_library_app/feature/book_details/presentation/pages/book_details_page.dart';
import 'package:book_library_app/feature/book_list/presentation/pages/book_list_page.dart';
import 'package:book_library_app/feature/book_search/presentation/pages/book_search_page.dart';
import 'package:book_library_app/feature/reading_progress/presentation/pages/reading_progress_page.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final currentUserId = args?['currentUserId'] as String? ?? 'defaultUserId';
        return BookListPage(currentUserId: currentUserId);
      },
    ),
    GoRoute(
      path: '/add-book',
      builder: (context, state) => const AddBookPage(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final currentUserId = args?['currentUserId'] as String? ?? 'defaultUserId';
        return BookSearchPage(currentUserId: currentUserId);
      },
    ),
    GoRoute(
      path: '/book-details',
      builder: (context, state) {
        final book = state.extra as  BookModel;
        return BookDetailsPage(book: book);
      },
    ),
    GoRoute(
      path: '/reading-progress',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final bookId = args['bookId'] as String;
        final userId = args['userId'] as String;
        return ReadingProgressPage(bookId: bookId, userId: userId);
      },
    ),
  ],
);