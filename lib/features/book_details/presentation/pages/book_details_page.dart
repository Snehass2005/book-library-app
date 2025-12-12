import 'dart:developer';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/features/book_details/data/models/rating_model.dart';
import 'package:book_library_app/features/book_details/data/models/recommendation_model.dart';
import 'package:book_library_app/features/book_details/data/models/reveiw_model.dart';
import 'package:book_library_app/features/book_details/domain/usecases/book_details_usecases.dart';
import 'package:book_library_app/features/book_details/presentation/cubit/book_details_cubit.dart';
import 'package:book_library_app/shared/config/dimens.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailsPage extends StatefulWidget {
  final BookModel book;
  const BookDetailsPage({super.key, required this.book});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late BookDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BookDetailsCubit(injector<BookUseCases>());
    log("🚀 BookDetailsPage init with Book ID: ${widget.book.id}");
    _cubit.loadDetails(widget.book.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: Scaffold(
        backgroundColor: AppColors.colorSecondary,
        appBar: AppBar(
          title: const Text('Book Details', style: AppTextStyles.openSansBold20),
          centerTitle: true,
          backgroundColor: AppColors.colorSecondary,
        ),
        body: BlocConsumer<BookDetailsCubit, BookDetailsState>(
          listener: (context, state) {
            if (state is BookDetailsError) {
              _showErrorSnackBar(context, state.message);
              _cubit.resetError();
            }
          },
          builder: (context, state) {
            log("📱 UI received state: $state");

            if (state is BookDetailsLoadingState) {
              log("⏳ Showing loading spinner");
              return Container(
                color: AppColors.colorSecondary,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            } else if (state is BookDetailsSuccess) {
              log("🖼 Rendering book: ${state.book.title}");
              return _buildBookDetails(
                state.book,
                reviews: state.reviews,
                rating: state.rating,
                recommendations: state.recommendations,
              );
            } else if (state is BookDetailsLoaded && state.isError) {
              log("❌ Error state: ${state.errorMessage}");
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else if (state is BookDetailsLoaded && !state.isLoading) {
              log("⚠️ Fallback: showing widget.book: ${widget.book.title}");
              return _buildBookDetails(widget.book);
            }

            log("⚠️ Unknown state, rendering fallback");
            return Center(
              child: Text('Unable to load book details.',
                  style: AppTextStyles.openSansRegular14),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookDetails(
      BookModel book, {
        List<ReviewModel>? reviews,
        RatingModel? rating,
        List<RecommendationModel>? recommendations,
      }) {
    log("🖼 Building details for book: ${book.title}");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimens.spacing_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Dimens.spacing_16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimens.radius_12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimens.radius_12),
                    child: book.coverUrl.isNotEmpty && book.coverUrl.startsWith('http')
                        ? Image.network(
                      book.coverUrl,
                      width: 160,
                      height: 240,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 80),
                    )
                        : const Icon(Icons.book, size: 80),
                  ),
                ),
                const SizedBox(height: Dimens.spacing_16),
                Text(book.title, style: AppTextStyles.openSansBold24),
                const SizedBox(height: Dimens.spacing_4),
                Text('by ${book.author}', style: AppTextStyles.openSansRegular14),
                const SizedBox(height: Dimens.spacing_16),
                Text('Category: ${book.category}',
                    style: AppTextStyles.openSansRegular14),
                const SizedBox(height: Dimens.spacing_24),
                Text('Description', style: AppTextStyles.openSansBold18),
                const SizedBox(height: Dimens.spacing_8),
                Text(book.description, style: AppTextStyles.openSansRegular14),
                const SizedBox(height: Dimens.spacing_24),

                // Rating
                Text('Rating', style: AppTextStyles.openSansBold18),
                const SizedBox(height: Dimens.spacing_8),
                if (rating != null)
                  Text('⭐ ${rating.average} (${rating.count} ratings)',
                      style: AppTextStyles.openSansRegular14)
                else
                  Text('⭐ No ratings yet',
                      style: AppTextStyles.openSansRegular14),
                const SizedBox(height: Dimens.spacing_24),

                // Reviews
                Text('Reviews', style: AppTextStyles.openSansBold18),
                const SizedBox(height: Dimens.spacing_8),
                if (reviews != null && reviews.isNotEmpty)
                  ...reviews.map((review) => Padding(
                    padding: const EdgeInsets.only(bottom: Dimens.spacing_12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.reviewer,
                            style: AppTextStyles.openSansBold14),
                        Text('"${review.comment}"',
                            style: AppTextStyles.openSansRegular14),
                        Text('⭐ ${review.rating}',
                            style: AppTextStyles.openSansRegular12),
                      ],
                    ),
                  ))
                else
                  Text('No reviews yet',
                      style: AppTextStyles.openSansRegular14),
                const SizedBox(height: Dimens.spacing_24),

                // Recommendations
                Text('Recommendations', style: AppTextStyles.openSansBold18),
                const SizedBox(height: Dimens.spacing_8),
                if (recommendations != null && recommendations.isNotEmpty)
                  ...recommendations.map((rec) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        rec.coverImage,
                        width: 40,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.book, size: 40),
                      ),
                    ),
                    title: Text(rec.title,
                        style: AppTextStyles.openSansBold14),
                    subtitle: Text('by ${rec.author} • ${rec.category}',
                        style: AppTextStyles.openSansRegular12),
                  ))
                else
                  Text('No recommendations available',
                      style: AppTextStyles.openSansRegular14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.colorRed),
    );
    log("ERROR ----- $message");
  }
}