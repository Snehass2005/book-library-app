import 'package:bloc/bloc.dart';
import 'package:book_library_app/feature/reading_progress/data/datasources/reading_progress_datasource.dart';
import 'package:book_library_app/feature/reading_progress/data/models/reading_progress_model.dart';
import 'package:book_library_app/feature/reading_progress/presentation/cubit/reading_progress_state.dart';



class ReadingProgressCubit extends Cubit<ReadingProgressState> {
  final ReadingProgressDataSource dataSource;

  ReadingProgressCubit(this.dataSource) : super(ReadingProgressInitial());

  Future<void> loadProgress(String bookId, String userId) async {
    emit(ReadingProgressLoading());
    try {
      final progress = await dataSource.getProgress(bookId, userId);
      emit(ReadingProgressLoaded(progress));
    } catch (e) {
      emit(ReadingProgressError('Failed to load progress'));
    }
  }

  Future<void> submitProgress(ReadingProgressModel progress) async {
    try {
      await dataSource.submitProgress(progress);
      emit(ReadingProgressSaved(progress));
    } catch (e) {
      emit(ReadingProgressError('Failed to save progress'));
    }
  }
}