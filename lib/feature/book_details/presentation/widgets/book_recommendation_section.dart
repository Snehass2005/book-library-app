import 'package:book_library_app/feature/book_details/presentation/cubit/book_details_cubit.dart';
import 'package:book_library_app/feature/book_details/presentation/cubit/book_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class BookRecommendationSection extends StatelessWidget {
  const BookRecommendationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookDetailsCubit, BookDetailsState>(
      builder: (context, state) {
        if (state is BookDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookDetailsLoaded) {
          final recommendations = state.recommendations;
          if (recommendations.isEmpty) {
            return const Text('No recommendations available.');
          }
          return Column(
            children: recommendations.map((book) {
              return ListTile(
                leading: Image.network(
                  book.coverImage,
                  width: 50,
                  errorBuilder: (_, __, ___) => const Icon(Icons.book),
                ),
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () => context.push('/book-details', extra: book),
              );
            }).toList(),
          );
        } else if (state is BookDetailsError) {
          return Text('Error loading recommendations: ${state.message}',
              style: const TextStyle(color: Colors.red));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}