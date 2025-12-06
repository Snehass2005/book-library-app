part of 'reading_progress_cubit.dart';

abstract class ReadingProgressState extends Equatable {
  const ReadingProgressState();

  @override
  List<Object?> get props => [];
}

/// Base loaded state with flags
class ReadingProgressLoaded extends ReadingProgressState {
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final ReadingProgressModel? progress;

  const ReadingProgressLoaded({
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
    this.progress,
  });

  ReadingProgressLoaded copyWith({
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    ReadingProgressModel? progress,
  }) {
    return ReadingProgressLoaded(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [isLoading, isError, errorMessage, progress];
}

/// Success state when progress is fetched
class ReadingProgressSuccess extends ReadingProgressState {
  final ReadingProgressModel progress;

  const ReadingProgressSuccess(this.progress);

  @override
  List<Object?> get props => [progress];
}

/// Success state when progress is saved
class ReadingProgressSaved extends ReadingProgressState {
  final ReadingProgressModel progress;

  const ReadingProgressSaved(this.progress);

  @override
  List<Object?> get props => [progress];
}