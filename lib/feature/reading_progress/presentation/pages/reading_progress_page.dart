
import 'package:book_library_app/feature/reading_progress/data/datasources/reading_progress_datasource.dart';
import 'package:book_library_app/feature/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:book_library_app/feature/reading_progress/presentation/widgets/reading_progress.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_library_app/shared/config/dimens.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';


class ReadingProgressPage extends StatelessWidget {
  final String bookId;
  final String userId;

  const ReadingProgressPage({super.key, required this.bookId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReadingProgressCubit(injector<ReadingProgressDataSource>())
        ..loadProgress(bookId, userId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Reading Progress',
            style: AppTextStyles.openSansBold20,
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(Dimens.spacing_16),
          child: ReadingProgressWidget(),
        ),
      ),
    );
  }
}