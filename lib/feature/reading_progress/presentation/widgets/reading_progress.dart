import 'package:book_library_app/feature/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:book_library_app/feature/reading_progress/presentation/cubit/reading_progress_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReadingProgressWidget extends StatelessWidget {
  const ReadingProgressWidget({super.key}); // ✅ No progress parameter

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingProgressCubit, ReadingProgressState>(
      builder: (context, state) {
        if (state is ReadingProgressLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReadingProgressLoaded || state is ReadingProgressSaved) {
          final progress = (state is ReadingProgressLoaded)
              ? state.progress
              : (state as ReadingProgressSaved).progress;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📖 Page ${progress.page}', style: Theme.of(context).textTheme.titleMedium),
              if (progress.chapter != null) Text('📚 ${progress.chapter}'),
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
        } else if (state is ReadingProgressError) {
          return const Text('Progress not available');
        }
        return const SizedBox.shrink();
      },
    );
  }
}