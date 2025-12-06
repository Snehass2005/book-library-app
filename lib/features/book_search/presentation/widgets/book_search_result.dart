import 'package:book_library_app/features/book_search/presentation/cubit/book_search_cubit.dart';
import 'package:flutter/cupertino.dart';
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
            return const Center(child: Text('No books found'));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.books.length,
            itemBuilder: (_, index) {
              final book = state.books[index];
              return ListTile(
                leading: Image.network(
                  book.coverUrl ?? '',
                  width: 50,
                  errorBuilder: (_, __, ___) => const Icon(Icons.book),
                ),
                title: Text(book.title),
                subtitle: Text(book.author),
              );
            },
          );
        } else if (state is BookSearchLoaded && state.isError) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}