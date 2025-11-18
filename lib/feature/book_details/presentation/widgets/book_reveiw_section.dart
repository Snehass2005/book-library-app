import 'package:book_library_app/feature/book_details/presentation/cubit/book_details_cubit.dart';
import 'package:book_library_app/feature/book_details/presentation/cubit/book_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BookReviewSection extends StatelessWidget {
  const BookReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookDetailsCubit, BookDetailsState>(
      builder: (context, state) {
        if (state is BookDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookDetailsLoaded) {
          final reviews = state.reviews;
          if (reviews.isEmpty) {
            return const Text('No reviews yet.');
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...reviews.map(
                    (review) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('- ${review.comment}'),
                ),
              ),
            ],
          );
        } else if (state is BookDetailsError) {
          return Text('Error loading reviews: ${state.message}');
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}