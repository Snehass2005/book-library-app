import 'package:book_library_app/features/book_details/presentation/pages/book_details_page.dart';
import 'package:book_library_app/features/book_search/presentation/cubit/book_search_cubit.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookSearchResult extends StatelessWidget {
  final String currentUserId;
  const BookSearchResult({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookSearchCubit, BookSearchState>(
      builder: (context, state) {
        if (state is BookSearchLoaded && state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookSearchSuccess) {
          if (state.books.isEmpty) {
            // ✅ Styled "No books found"
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.greyText.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.greyText),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No books found',
                        style: AppTextStyles.openSansRegular14.copyWith(
                          color: AppColors.greyText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ✅ Show search results list
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.books.length,
            itemBuilder: (_, index) {
              final book = state.books[index];
              final imageUrl = book.coverUrl ?? '';
              final isValid = imageUrl.isNotEmpty &&
                  (imageUrl.startsWith('http') || imageUrl.startsWith('https'));

              final imageWidget = isValid
                  ? Image.network(
                imageUrl,
                width: 50,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.greyText.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.book_outlined,
                      size: 30, color: AppColors.greyText),
                ),
              )
                  : Container(
                width: 50,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.greyText.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.book_outlined,
                    size: 30, color: AppColors.greyText),
              );

              return ListTile(
                leading: imageWidget,
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailsPage(book: book),
                    ),
                  );
                },
              );

            },
          );
        } else if (state is BookSearchLoaded && state.isError) {
          // ✅ Styled error card
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.colorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.colorRed),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Oops! ${state.errorMessage}',
                      style: AppTextStyles.openSansRegular14.copyWith(
                        color: AppColors.colorRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}