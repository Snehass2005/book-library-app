import 'package:book_library_app/feature/book_details/domain/usecases/book_details_usecases.dart';
import 'package:book_library_app/feature/book_details/presentation/cubit/book_details_cubit.dart';
import 'package:book_library_app/feature/book_details/presentation/widgets/book_rating_section.dart';
import 'package:book_library_app/feature/book_details/presentation/widgets/book_recommendation_section.dart';
import 'package:book_library_app/feature/book_details/presentation/widgets/book_reveiw_section.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/shared/config/dimens.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';

class BookDetailsPage extends StatelessWidget {
  final BookModel book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => BookDetailsCubit(injector<BookUseCases>())..loadDetails(book.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(book.title, style: AppTextStyles.openSansBold24),
          centerTitle: true,
          backgroundColor: AppColors.colorSecondary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimens.spacing_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.radius_12),
                  child: Image.network(
                    book.coverUrl,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
              const SizedBox(height: Dimens.spacing_20),
              Text(book.title, style: AppTextStyles.openSansBold24.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: Dimens.spacing_8),
              Text('by ${book.author}', style: AppTextStyles.openSansRegular14.copyWith(color: AppColors.greyText)),
              const SizedBox(height: Dimens.spacing_16),
              Card(
                elevation: Dimens.elevation_2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.radius_16)),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.spacing_16),
                  child: Text(book.description, style: AppTextStyles.openSansRegular14),
                ),
              ),
              const SizedBox(height: Dimens.spacing_24),
              Text('Recommended Books', style: AppTextStyles.openSansBold20),
              const SizedBox(height: Dimens.spacing_8),
              const BookRecommendationSection(),
              const SizedBox(height: Dimens.spacing_16),
              const BookRatingSection(bookId: '',),
              const SizedBox(height: Dimens.spacing_24),
              Text('Reviews', style: AppTextStyles.openSansBold20),
              const SizedBox(height: Dimens.spacing_8),
              const BookReviewSection(),
            ],
          ),
        ),
      ),
    );
  }
}