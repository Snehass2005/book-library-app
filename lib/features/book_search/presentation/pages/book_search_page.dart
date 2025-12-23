import 'dart:developer';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/features/book_search/domain/usecases/book_search_usecases.dart';
import 'package:book_library_app/features/book_search/presentation/cubit/book_search_cubit.dart';
import 'package:book_library_app/features/book_search/presentation/widgets/book_search_input.dart';
import 'package:book_library_app/features/book_search/presentation/widgets/book_search_result.dart';
import 'package:book_library_app/shared/config/dimens.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookSearchPage extends StatefulWidget {
  final String currentUserId;
  const BookSearchPage({super.key, required this.currentUserId});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  late BookSearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    final useCase = injector<SearchBooksUseCase>();
    _searchCubit = BookSearchCubit(useCase);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _searchCubit,
      child: Scaffold(
        appBar: AppBar(
      title: const Text('Search Books'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context); // ✅ Go back to BookListPage
        },
      ),),
      body: Padding(
          padding: const EdgeInsets.all(Dimens.spacing_16),
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
                return BookSearchResult(currentUserId: widget.currentUserId);
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
              return Column(
                children: [
                  BookSearchInput(
                    onSearch: (query) =>
                        context.read<BookSearchCubit>().search(query),
                  ),
                  const SizedBox(height: Dimens.spacing_16),
                  const Expanded(child: SizedBox.shrink()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    log("ERROR ----- $message");
  }
}