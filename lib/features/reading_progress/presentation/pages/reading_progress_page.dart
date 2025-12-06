import 'dart:developer';
import 'package:book_library_app/core/constants/routes.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/core/utils/configuration.dart';
import 'package:book_library_app/features/reading_progress/data/models/reading_progress_model.dart';
import 'package:book_library_app/features/reading_progress/domain/usecases/reading_progress_usecases.dart';
import 'package:book_library_app/features/reading_progress/presentation/cubit/reading_progress_cubit.dart';
import 'package:book_library_app/shared/config/dimens.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:go_router/go_router.dart';

class ReadingProgressPage extends StatefulWidget {
  final String bookId;
  final String userId;

  const ReadingProgressPage({
    super.key,
    required this.bookId,
    required this.userId,
  });

  @override
  State<ReadingProgressPage> createState() => _ReadingProgressPageState();
}

class _ReadingProgressPageState extends State<ReadingProgressPage> {
  late ReadingProgressCubit _progressCubit;

  @override
  void initState() {
    super.initState();
    _initializeCubit();
  }

  void _initializeCubit() {
    final useCases = injector<ReadingProgressUseCases>();
    _progressCubit = ReadingProgressCubit(useCases);
    _progressCubit.loadProgress(widget.bookId, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _progressCubit,
      child: Scaffold(
        backgroundColor: AppColors.appBackGround,
        body: Padding(
          padding: const EdgeInsets.all(Dimens.spacing_40),
          child: BlocConsumer<ReadingProgressCubit, ReadingProgressState>(
            listener: (context, state) {
              if (state is ReadingProgressSaved) {
                context.go(RoutesName.readingProgress);
              } else if (state is ReadingProgressLoaded) {
                if (state.isError) {
                  _showErrorSnackBar(context, state.errorMessage);
                  _progressCubit.resetError();
                }
              }
            },
            builder: (context, state) {
              if (state is ReadingProgressLoaded && state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ReadingProgressSuccess) {
                final progress = state.progress;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "READING_PROGRESS".tr,
                      style: const TextStyle(
                        fontSize: Dimens.spacing_36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: Dimens.spacing_20),
                    Text(
                      "Page ${progress.page}",   // ✅ use page
                      style: const TextStyle(
                        fontSize: Dimens.spacing_18,
                        color: AppColors.colorPrimary,
                      ),
                    ),
                    const SizedBox(height: Dimens.spacing_20),
                    LinearProgressIndicator(
                      value: progress.percentage / 100,
                      backgroundColor: Colors.grey,
                      color: AppColors.colorPrimary,
                    ),
                    const SizedBox(height: Dimens.spacing_40),
                    ElevatedButton(
                      onPressed: () {
                        final updated = ReadingProgressModel(
                          bookId: progress.bookId,
                          userId: progress.userId,
                          page: progress.page + 1, // ✅ use page
                          percentage: ((progress.page + 1) / 100) * 100, // adjust logic if needed
                          timestamp: DateTime.now(),
                        );
                        context.read<ReadingProgressCubit>().submitProgress(updated);
                      },
                      child: Text("MARK_NEXT_PAGE".tr.toUpperCase()),
                    ),
                  ],
                );
              } else if (state is ReadingProgressLoaded && state.isError) {
                return buildFieldValidation(state.errorMessage);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Align buildFieldValidation(String errorValue) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        errorValue,
        style: const TextStyle(
          color: AppColors.colorRed,
          fontSize: Dimens.spacing_12,
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    log("ERROR ----- $message");
  }
}