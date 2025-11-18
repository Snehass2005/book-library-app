import 'package:book_library_app/feature/book_list/presentation/widgets/book_card.dart';
import 'package:book_library_app/feature/book_search/data/datasources/book_search_datasource.dart';
import 'package:book_library_app/feature/book_search/presentation/cubit/book_search_cubit.dart';
import 'package:book_library_app/feature/book_search/presentation/cubit/book_search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';


class BookSearchDelegate extends SearchDelegate {
  final String currentUserId;

  BookSearchDelegate({required this.currentUserId});

  late final BookSearchCubit _searchCubit = BookSearchCubit(injector<BookSearchDataSource>());

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () => query = '',
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) {
    _searchCubit.search(query);

    return BlocProvider.value(
      value: _searchCubit,
      child: BlocBuilder<BookSearchCubit, BookSearchState>(
        builder: (context, state) {
          if (state is BookSearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookSearchLoaded) {
            final results = state.books; // ✅ Fixed field name
            if (results.isEmpty) {
              return Center(
                child: Text(
                  'No books found.',
                  style: AppTextStyles.openSansRegular14.copyWith(color: AppColors.greyText),
                ),
              );
            }
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final book = results[index].toModel();
                return BookCard(book: book, currentUserId: currentUserId);
              },
            );
          } else if (state is BookSearchError) {
            return Center(
              child: Text(
                state.message,
                style: AppTextStyles.openSansRegular14.copyWith(color: AppColors.colorRed),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => const SizedBox.shrink();
}