import 'package:book_library_app/feature/book_search/data/datasources/book_search_datasource.dart';
import 'package:book_library_app/feature/book_search/presentation/cubit/book_search_cubit.dart';
import 'package:book_library_app/feature/book_search/presentation/widgets/book_search_input.dart';
import 'package:book_library_app/feature/book_search/presentation/widgets/book_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/shared/config/dimens.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';

class BookSearchPage extends StatelessWidget {
  final String currentUserId;
  const BookSearchPage({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookSearchCubit(injector<BookSearchDataSource>()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Search Books',
            style: AppTextStyles.openSansBold20,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Dimens.spacing_16),
          child: Column(
            children: [
              BookSearchInput(
                onSearch: (query) => context.read<BookSearchCubit>().search(query),
              ),
              const SizedBox(height: Dimens.spacing_16),
              const Expanded(child: BookSearchResult()),
            ],
          ),
        ),
      ),
    );
  }
}