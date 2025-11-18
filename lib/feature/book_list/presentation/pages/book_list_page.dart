import 'package:book_library_app/feature/book_list/domain/usecases/book_list_usecases.dart';
import 'package:book_library_app/feature/book_list/presentation/cubit/book_list_cubit.dart';
import 'package:book_library_app/feature/book_list/presentation/cubit/book_list_state.dart';
import 'package:book_library_app/feature/book_search/presentation/pages/book_search_delegate.dart';
import 'package:book_library_app/shared/config/dimens.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class BookListPage extends StatefulWidget {
  final String currentUserId;
  const BookListPage({super.key, required this.currentUserId});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late BookListCubit _bookCubit;

  @override
  void initState() {
    super.initState();
    _bookCubit = BookListCubit(GetIt.instance<BookListUseCases>())..loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bookCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Book Library', style: AppTextStyles.openSansBold20),
          centerTitle: true,
          backgroundColor: AppColors.colorSecondary,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: BookSearchDelegate(currentUserId: widget.currentUserId),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<BookListCubit, BookListState>(
          builder: (context, state) {
            if (state is BookListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookListError) {
              return Center(
                child: Text(state.message, style: AppTextStyles.openSansRegular14),
              );
            } else if (state is BookListLoaded) {
              final books = state.books;

              final Map<String, List<BookModel>> groupedBooks = {};
              for (var book in books) {
                final category = book.category.isNotEmpty ? book.category : 'Uncategorized';
                groupedBooks.putIfAbsent(category, () => []).add(book);
              }

              final categories = groupedBooks.entries.map((entry) {
                return {
                  'title': entry.key,
                  'count': entry.value.length,
                  'description': 'Explore books in ${entry.key}',
                  'books': entry.value,
                };
              }).toList();

              return ListView.builder(
                padding: const EdgeInsets.all(Dimens.spacing_16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    elevation: Dimens.elevation_2,
                    margin: const EdgeInsets.symmetric(vertical: Dimens.spacing_12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.radius_16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.spacing_16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category['title'] as String, style: AppTextStyles.openSansBold18),
                          const SizedBox(height: Dimens.spacing_4),
                          Text('${category['count']} Books', style: AppTextStyles.openSansRegular14),
                          const SizedBox(height: Dimens.spacing_8),
                          Text(
                            category['description'] as String,
                            style: AppTextStyles.openSansRegular14.copyWith(color: AppColors.greyText),
                          ),
                          const SizedBox(height: Dimens.spacing_12),
                          Wrap(
                            spacing: Dimens.spacing_8,
                            runSpacing: Dimens.spacing_8,
                            children: (category['books'] as List<BookModel>).map((book) {
                              return GestureDetector(
                                onTap: () => context.push('/book-details', extra: book),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimens.radius_8),
                                  child: Image.network(
                                    book.coverUrl ?? '',
                                    width: Dimens.spacing_60,
                                    height: Dimens.spacing_90,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const CircularProgressIndicator();
                                    },
                                    errorBuilder: (_, __, ___) =>
                                        Icon(Icons.broken_image, color: AppColors.colorBlack),
                                  ),
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
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/add-book'),
          icon: const Icon(Icons.add),
          label: Text(
            'Add Book',
            style: AppTextStyles.openSansBold14.copyWith(color: AppColors.colorWhite),
          ),
          backgroundColor: AppColors.colorSecondary,
        ),
      ),
    );
  }
}