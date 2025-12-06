import 'dart:developer';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/features/book_list/presentation/widgets/book_card.dart';
import 'package:book_library_app/features/book_search/domain/usecases/book_search_usecases.dart';
import 'package:book_library_app/features/book_search/presentation/cubit/book_search_cubit.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookSearchDelegate extends SearchDelegate {
  final String currentUserId;

  BookSearchDelegate({required this.currentUserId});

  late final BookSearchCubit _searchCubit =
  BookSearchCubit(injector<SearchBooksUseCase>());

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
      child: BlocConsumer<BookSearchCubit, BookSearchState>(
        listener: (context, state) {
          if (state is BookSearchLoaded && state.isError) {
            _showErrorSnackBar(context, state.errorMessage);
            _searchCubit.resetError();
          }
        },
        builder: (context, state) {
          if (state is BookSearchLoaded && state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookSearchSuccess) {
            final results = state.books;
            if (results.isEmpty) {
              return Center(
                child: Text(
                  'No books found.',
                  style: AppTextStyles.openSansRegular14.copyWith(
                    color: AppColors.greyText,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final book = results[index];
                return BookCard(book: book, currentUserId: currentUserId);
              },
            );
          } else if (state is BookSearchLoaded && state.isError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: AppTextStyles.openSansRegular14.copyWith(
                  color: AppColors.colorRed,
                ),
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

  void _showErrorSnackBar(BuildContext context, String message) {
    log("ERROR ----- $message");
  }
}