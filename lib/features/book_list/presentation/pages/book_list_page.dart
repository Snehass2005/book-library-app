import 'dart:developer';
import 'package:book_library_app/core/constants/routes.dart';
import 'package:book_library_app/features/book_search/presentation/pages/book_search_page.dart';
import 'package:book_library_app/shared/config/book_sort_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:book_library_app/features/book_list/presentation/cubit/book_list_cubit.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';
import 'package:book_library_app/shared/config/dimens.dart';

// ✅ Import search feature widgets
import 'package:book_library_app/features/book_search/domain/usecases/book_search_usecases.dart';
import 'package:book_library_app/features/book_search/presentation/cubit/book_search_cubit.dart';
import 'package:book_library_app/features/book_search/presentation/widgets/book_search_input.dart';
import 'package:book_library_app/features/book_search/presentation/widgets/book_search_result.dart';

class BookListPage extends StatefulWidget {
  final String currentUserId;
  const BookListPage({super.key, required this.currentUserId});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late BookListCubit _bookListCubit;
  late BookSearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _bookListCubit = BookListCubit()..loadBooks(sortType: BookSortType.createdAt);
    _searchCubit = BookSearchCubit(injector<SearchBooksUseCase>());
  }

  @override
  void dispose() {
    _bookListCubit.close();
    _searchCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bookListCubit),
        BlocProvider.value(value: _searchCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Book Library', style: AppTextStyles.openSansBold20),
          centerTitle: true,
          backgroundColor: AppColors.colorSecondary,
        ),
        body: Column(
          children: [
            // ✅ Search bar at the top
            Padding(
              padding: const EdgeInsets.all(Dimens.spacing_16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookSearchPage(currentUserId: widget.currentUserId),
                    ),
                  );
                },
                child: AbsorbPointer( // makes this bar not editable here
                  child: BookSearchInput(onSearch: (_) {}),
                ),
              ),
            ),
            // ✅ Show search results if any, else show full list
            Expanded(
              child: BlocBuilder<BookSearchCubit, BookSearchState>(
                builder: (context, state) {
                  if (state is BookSearchLoaded && state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BookSearchSuccess) {
                    if (state.books.isEmpty) {
                      return const Center(child: Text('No books found'));
                    }
                    return BookSearchResult(currentUserId: widget.currentUserId);
                  }
                  // Default: show full book list
                  return BlocConsumer<BookListCubit, BookListState>(
                    listener: (context, state) {
                      if (state is BookListError) {
                        _showErrorSnackBar(context, state.errorMessage);
                        _bookListCubit.resetError();
                      }
                    },
                    builder: (context, state) {
                      if (state is BookListLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is BookListSuccess) {
                        if (state.books.isEmpty) {
                          return const Center(child: Text('No books found'));
                        }
                        return _buildBookList(state.books);
                      } else if (state is BookListError) {
                        final books = state.books;
                        if (books.isNotEmpty) return _buildBookList(books);
                        return Center(
                          child: Text(state.errorMessage,
                              style: AppTextStyles.openSansRegular14),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/add-book'),
          icon: const Icon(Icons.add),
          label: Text('Add Book',
              style: AppTextStyles.openSansBold14
                  .copyWith(color: AppColors.colorWhite)),
          backgroundColor: AppColors.colorSecondary,
        ),
      ),
    );
  }

  Widget _buildBookList(List<BookModel> books) {
    final Map<String, List<BookModel>> groupedBooks = {};

    for (var book in books) {
      final category = book.category.trim().isEmpty ? 'Uncategorized' : book.category.trim();
      groupedBooks.putIfAbsent(category, () => []).add(book);
    }

    final sortedCategories = groupedBooks.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));

    return ListView.builder(
      padding: const EdgeInsets.all(Dimens.spacing_16),
      itemCount: sortedCategories.length,
      itemBuilder: (context, index) {
        final entry = sortedCategories[index];
        final categoryName = entry.key;
        final booksInCategory = entry.value;

        BookSortType localSort = BookSortType.createdAt;

        return StatefulBuilder(
          builder: (context, setState) {
            List<BookModel> sortedBooks = List.from(booksInCategory);

            switch (localSort) {
              case BookSortType.alphabetAZ:
                sortedBooks.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
                break;
              case BookSortType.alphabetZA:
                sortedBooks.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
                break;
              case BookSortType.createdAt:
                sortedBooks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                break;
              case BookSortType.updatedAt:
                sortedBooks.sort((a, b) {
                  final aTime = a.updatedAt ?? a.createdAt;
                  final bTime = b.updatedAt ?? b.createdAt;
                  return bTime.compareTo(aTime);
                });
                break;
            }

            return Card(
              elevation: Dimens.elevation_4,
              margin: const EdgeInsets.symmetric(vertical: Dimens.spacing_12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radius_16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Dimens.spacing_16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(categoryName, style: AppTextStyles.openSansBold18),
                        ),
                        DropdownButton<BookSortType>(
                          value: localSort,
                          onChanged: (newSort) {
                            if (newSort != null) {
                              setState(() => localSort = newSort);
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                                value: BookSortType.alphabetAZ,
                                child: Text("A → Z")),
                            DropdownMenuItem(
                                value: BookSortType.alphabetZA,
                                child: Text("Z → A")),
                            DropdownMenuItem(
                                value: BookSortType.createdAt,
                                child: Text("Created Date")),
                            DropdownMenuItem(
                                value: BookSortType.updatedAt,
                                child: Text("Updated Date")),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimens.spacing_8),
                    Wrap(
                      spacing: Dimens.spacing_8,
                      runSpacing: Dimens.spacing_8,
                      children: sortedBooks.map((book) {
                        final imageUrl = book.coverUrl;
                        final isValid = imageUrl.isNotEmpty &&
                            (imageUrl.startsWith('http') || imageUrl.startsWith('https'));

                        final imageWidget = isValid
                            ? Image.network(imageUrl, width: 60, height: 90, fit: BoxFit.cover)
                            : Container(
                          width: 60,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.greyText.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.book_outlined, size: 40, color: AppColors.greyText),
                        );

                        return GestureDetector(
                          onTap: () => context.push('/book-details', extra: book),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imageWidget,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    log("ERROR ----- $message");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.colorRed),
    );
  }
}