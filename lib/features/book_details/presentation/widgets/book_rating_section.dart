import 'package:book_library_app/features/book_details/presentation/cubit/book_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookRatingSection extends StatelessWidget {
  const BookRatingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookDetailsCubit, BookDetailsState>(
      builder: (context, state) {
        if (state is BookDetailsLoadingState) {
          return const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        } else if (state is BookDetailsSuccess) {
          final rating = state.rating;
          if (rating == null || rating.count == 0 || rating.average == 0.0) {
            return const Text('No ratings yet');
          }

          return Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                rating.average.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text('(${rating.count} ratings)'),
            ],
          );
        } else if (state is BookDetailsError) {
          return const Text('Rating not available');
        }

        return const SizedBox.shrink();
      },
    );
  }
}