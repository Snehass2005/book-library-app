import 'dart:developer';

import 'package:book_library_app/core/constants/routes.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/features/add_book/domain/usecases/add_book_usecases.dart';
import 'package:book_library_app/features/add_book/presentation/cubit/add_book_page_cubit.dart';
import 'package:book_library_app/features/book_list/domain/usecases/book_list_usecases.dart';
import 'package:book_library_app/features/book_list/presentation/cubit/book_list_cubit.dart';
import 'package:book_library_app/shared/config/dimens.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';
import 'package:book_library_app/features/add_book/presentation/widgets/book_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  late AddBookCubit _addBookCubit;
  late BookListCubit _bookListCubit;

  @override
  void initState() {
    super.initState();
    final addBookUseCase = injector<AddBookUseCase>();
    final bookListUseCases = injector<BookListUseCases>();

    _addBookCubit = AddBookCubit(addBookUseCase);
    _bookListCubit = BookListCubit(bookListUseCases);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddBookCubit>(create: (_) => _addBookCubit),
        BlocProvider<BookListCubit>(create: (_) => _bookListCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColors.colorSecondary,
        appBar: AppBar(
          title: const Text('Add Book', style: AppTextStyles.openSansBold20),
          centerTitle: true,
          backgroundColor: AppColors.colorSecondary,
          elevation: Dimens.elevation_2,
        ),
        body: Container(
          color: AppColors.colorSecondary,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.spacing_16),
              child: BlocConsumer<AddBookCubit, AddBookState>(
                listener: (context, state) {
                  if (state is AddBookSuccess) {
                    // ✅ Refresh BookList immediately after success
                    context.read<BookListCubit>().loadBooks();
                    context.go(RoutesName.defaultPath);
                  } else if (state.isError) {
                    _showErrorSnackBar(context, state.errorMessage);
                    _addBookCubit.resetError();
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Card(
                      elevation: Dimens.elevation_4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.radius_16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimens.spacing_16),
                        child: BookForm(
                          onSubmit: (BookModel book) async {
                            await context.read<AddBookCubit>().addBook(book);
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.colorSecondary,
      ),
    );
    log("ERROR ----- $message");
  }
}