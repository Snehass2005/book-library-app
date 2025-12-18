import 'package:book_library_app/core/database/hive_storage_services.dart';
import 'package:flutter/material.dart';
import 'package:book_library_app/core/dependency_injection/injector.dart';
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:book_library_app/shared/theme/app_colors.dart';
import 'package:book_library_app/shared/theme/text_styles.dart';
import 'package:book_library_app/shared/config/dimens.dart';
import 'package:book_library_app/core/database/storage_services.dart';

class EditBookPage extends StatefulWidget {
  final BookModel book;
  const EditBookPage({super.key, required this.book});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController coverUrlController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.book.title);
    authorController = TextEditingController(text: widget.book.author);
    descriptionController = TextEditingController(text: widget.book.description);
    categoryController = TextEditingController(text: widget.book.category);
    coverUrlController = TextEditingController(text: widget.book.coverUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book', style: AppTextStyles.openSansBold20),
        backgroundColor: AppColors.colorSecondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.spacing_16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: authorController, decoration: const InputDecoration(labelText: 'Author')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
            TextField(controller: coverUrlController, decoration: const InputDecoration(labelText: 'Cover URL')),
            const SizedBox(height: Dimens.spacing_24),
            ElevatedButton(
              onPressed: () async {
                final updatedBook = widget.book.copyWith(
                  title: titleController.text,
                  author: authorController.text,
                  description: descriptionController.text,
                  category: categoryController.text,
                  coverUrl: coverUrlController.text,
                );

                final hiveService = injector<HiveService>();
                final success = await hiveService.updateBook(updatedBook);

                if (success) {
                  Navigator.pop(context); // go back to details/list
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update book')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.colorSecondary),
              child: const Text('Save Changes',style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}