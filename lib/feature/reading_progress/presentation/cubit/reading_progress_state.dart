


import 'package:book_library_app/feature/reading_progress/data/models/reading_progress_model.dart';

abstract class ReadingProgressState {}

class ReadingProgressInitial extends ReadingProgressState {}

class ReadingProgressLoading extends ReadingProgressState {}

class ReadingProgressLoaded extends ReadingProgressState {
  final ReadingProgressModel progress;
  ReadingProgressLoaded(this.progress);
}

class ReadingProgressSaved extends ReadingProgressState {
  final ReadingProgressModel progress;
  ReadingProgressSaved(this.progress);
}

class ReadingProgressError extends ReadingProgressState {
  final String message;
  ReadingProgressError(this.message);
}