import 'package:book_library_app/feature/book_search/presentation/cubit/book_search_cubit.dart';
import 'package:book_library_app/feature/book_search/presentation/cubit/book_search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookSearchResult extends StatelessWidget {
  const BookSearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookSearchCubit, BookSearchState>(
      builder: (context, state) {
        if (state is BookSearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookSearchLoaded) {
          if (state.books.isEmpty) return const Text('No books found');
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.books.length,
            itemBuilder: (_, index) {
              final book = state.books[index];
              return ListTile(
                leading: Image.network(
                  book.coverUrl,
                  width: 50,
                  errorBuilder: (_, __, ___) => const Icon(Icons.book),
                ),
                title: Text(book.title),
                subtitle: Text(book.author),
              );
            },
          );
        } else if (state is BookSearchError) {
          return Text('Error: ${state.message}');
        }
        return const SizedBox.shrink();
      },
    );
  }
}