import 'package:book_library_app/feature/add_book/presentation/cubit/add_book_page_cubit.dart';
import 'package:book_library_app/feature/add_book/presentation/widgets/book_form.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/shared/config/dimens.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  late AddBookCubit _addBookCubit;

  @override
  void initState() {
    super.initState();
    _addBookCubit = injector<AddBookCubit>();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _addBookCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Book', style: AppTextStyles.openSansBold20),
          centerTitle: true,
          backgroundColor: AppColors.colorSecondary,
          elevation: Dimens.elevation_2,
        ),
        body: Container(
          color: AppColors.colorSecondaryLight,
          padding: const EdgeInsets.all(Dimens.spacing_16),
          child: Card(
            elevation: Dimens.elevation_4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.radius_16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.spacing_16),
              child: BookForm(
                onSubmit: (BookModel book) async {
                  await _addBookCubit.addBook(book);
                  if (context.mounted) context.pop();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}