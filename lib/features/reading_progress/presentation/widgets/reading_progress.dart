import 'package:book_library_app/features/reading_progress/data/models/reading_progress_model.dart';
import 'package:book_library_app/features/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReadingProgressWidget extends StatelessWidget {
  const ReadingProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingProgressCubit, ReadingProgressState>(
      builder: (context, state) {
        // ✅ Handle base loaded state with flags
        if (state is ReadingProgressLoaded) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isError) {
            return Text(
              'Error: ${state.errorMessage}',
              style: const TextStyle(color: Colors.red),
            );
          }
          if (state.progress != null) {
            final progress = state.progress!;
            return _buildProgressUI(context, progress);
          }
        }

        // ✅ Handle success state
        else if (state is ReadingProgressSuccess) {
          return _buildProgressUI(context, state.progress);
        }

        // ✅ Handle saved state
        else if (state is ReadingProgressSaved) {
          return _buildProgressUI(context, state.progress);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProgressUI(BuildContext context, ReadingProgressModel progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('📖 Page ${progress.page}',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.percentage / 100,
          backgroundColor: Colors.grey[300],
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 4),
        Text('${progress.percentage.toStringAsFixed(1)}% completed',
            style: Theme.of(context).textTheme.labelSmall),
        Text('🕒 Last updated: ${progress.timestamp.toLocal()}',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            context.push('/reader', extra: {
              'bookId': progress.bookId,
              'startPage': progress.page,
            });
          },
          child: const Text('Resume Reading'),
        ),
      ],
    );
  }
}