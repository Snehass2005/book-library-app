import 'dart:developer';
import 'package:book_library_app/core/constants/routes.dart';
import 'package:book_library_app/shared/config/book_sort_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:book_library_app/features/book_list/presentation/cubit/book_list_cubit.dart';
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
    _bookListCubit = BookListCubit()..loadBooks(sortType: BookSortType.createdAt);
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
        ),
        body: Column(
          children: [
            // ✅ Search bar + Filter icon in one line
            Padding(
              padding: const EdgeInsets.all(Dimens.spacing_16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search books...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      ),
                      onChanged: (query) {
                        _bookListCubit.searchBooks(query); // ✅ live search
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      _showSortDialog(context); // ✅ opens sorting options
                    },
                  ),
                ],
              ),
            ),
            // ✅ Show search results if any, else show full list
            Expanded(
              child: BlocConsumer<BookListCubit, BookListState>(
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
                    return _buildFlatBookList(state.books);
                  } else if (state is BookListError) {
                    final books = state.books;
                    if (books.isNotEmpty) return _buildFlatBookList(books);
                    return Center(
                      child: Text(state.errorMessage,
                          style: AppTextStyles.openSansRegular14),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/add-book'),
          icon: const Icon(Icons.add),
          label: Text('Add Book',
              style: AppTextStyles.openSansBold14.copyWith(color: AppColors.colorWhite)),
          backgroundColor: AppColors.colorSecondary,
        ),
      ),
    );
  }

  // ✅ Flat list (no local sorting, Cubit handles it)
  Widget _buildFlatBookList(List<BookModel> books) {
    return ListView.builder(
      padding: const EdgeInsets.all(Dimens.spacing_16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
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

        return Card(
          elevation: Dimens.elevation_2,
          margin: const EdgeInsets.symmetric(vertical: Dimens.spacing_8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radius_12),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageWidget,
            ),
            title: Text(book.title, style: AppTextStyles.openSansBold16),
            subtitle: Text(book.author, style: AppTextStyles.openSansRegular14),
            onTap: () => context.push('/book-details', extra: book),
          ),
        );
      },
    );
  }

  // ✅ Sorting dialog for filter icon
  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sort Books'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("A → Z"),
              onTap: () {
                _bookListCubit.loadBooks(sortType: BookSortType.alphabetAZ);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Z → A"),
              onTap: () {
                _bookListCubit.loadBooks(sortType: BookSortType.alphabetZA);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Created Date"),
              onTap: () {
                _bookListCubit.loadBooks(sortType: BookSortType.createdAt);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Updated Date"),
              onTap: () {
                _bookListCubit.loadBooks(sortType: BookSortType.updatedAt);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    log("ERROR ----- $message");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.colorRed),
    );
  }
}