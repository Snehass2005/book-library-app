import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:book_library_app/features/book_list/presentation/cubit/book_list_cubit.dart';
import 'package:book_library_app/features/book_list/domain/usecases/book_list_usecases.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';
import 'package:book_library_app/shared/config/dimens.dart';

class BookListPage extends StatefulWidget {
  final String currentUserId;
  const BookListPage({super.key, required this.currentUserId});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late BookListCubit _bookListCubit;

  @override
  void initState() {
    super.initState();
    _bookListCubit = BookListCubit()..loadBooks();
  }

  @override
  void dispose() {
    _bookListCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bookListCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Book Library', style: AppTextStyles.openSansBold20),
          centerTitle: true,
          backgroundColor: AppColors.colorSecondary,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.push('/book-search', extra: widget.currentUserId),
            ),
          ],
        ),
        body: BlocConsumer<BookListCubit, BookListState>(
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
              if (state.books.isEmpty) return const Center(child: Text('No books found'));
              return RefreshIndicator(
                onRefresh: () => _bookListCubit.refreshBooks(),
                child: _buildBookList(state.books),
              );

            } else if (state is BookListError) {
              final books = state.books;
              if (books.isNotEmpty) return _buildBookList(books);
              return Center(child: Text(state.errorMessage, style: AppTextStyles.openSansRegular14));
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/add-book'),
          icon: const Icon(Icons.add),
          label: Text('Add Book', style: AppTextStyles.openSansBold14.copyWith(color: AppColors.colorWhite)),
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
                Text(category['description'] as String,
                    style: AppTextStyles.openSansRegular14.copyWith(color: AppColors.greyText)),
                const SizedBox(height: Dimens.spacing_12),
                Wrap(
                  spacing: Dimens.spacing_8,
                  runSpacing: Dimens.spacing_8,
                  children: (category['books'] as List<BookModel>).map((book) {
                    final imageUrl = book.coverUrl;
                    final bool isUrlValid = imageUrl.isNotEmpty &&
                        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

                    Widget imageWidget;
                    if (isUrlValid) {
                      imageWidget = Image.network(
                        imageUrl,
                        width: Dimens.spacing_60,
                        height: Dimens.spacing_90,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(width: 24, height: 24, child: CircularProgressIndicator());
                        },
                        errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: AppColors.colorBlack),
                      );
                    } else {
                      imageWidget = Container(
                        width: Dimens.spacing_60,
                        height: Dimens.spacing_90,
                        decoration: BoxDecoration(
                          color: AppColors.greyText.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(Dimens.radius_8),
                        ),
                        child: Icon(Icons.book_outlined, size: Dimens.spacing_40, color: AppColors.greyText),
                      );
                    }

                    return GestureDetector(
                      onTap: () => context.push('/book-details', extra: book),
                      child: ClipRRect(borderRadius: BorderRadius.circular(Dimens.radius_8), child: imageWidget),
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

  void _showErrorSnackBar(BuildContext context, String message) {
    log("ERROR ----- $message");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.colorRed),
    );
  }
}
