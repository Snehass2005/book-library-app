
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:flutter/material.dart';


class BookForm extends StatefulWidget {
  final Future<void> Function(BookModel) onSubmit;
  final TextEditingController categoryController = TextEditingController();


  BookForm({super.key, required this.onSubmit});

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coverUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _coverUrlController.dispose();
    super.dispose();
  }

  void _submit() async {
    print("🔘 Submit button pressed");
    if (_formKey.currentState?.validate() ?? false) {
      print("✅ Form is valid");
      print("📘 Title: ${_titleController.text}");
      print("✍️ Author: ${_authorController.text}");
      print("📝 Description: ${_descriptionController.text}");
      print("🖼️ Cover URL: ${_coverUrlController.text}");
      print("📂 Category: ${widget.categoryController.text}");

      final book = BookModel(
        id: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
        coverUrl: _coverUrlController.text.trim(),
        category: widget.categoryController.text.trim(),
      );
      print("📦 BookModel created: ${book.title} (${book.category})");

      await widget.onSubmit(book);
      print("📤 Book submitted to onSubmit");
    } else {
      print("❌ Form is invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
              value == null || value.isEmpty ? 'Please enter a title' : null,
            ),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author'),
              validator: (value) =>
              value == null || value.isEmpty ? 'Please enter an author' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            TextFormField(
              controller: _coverUrlController,
              decoration: const InputDecoration(labelText: 'Cover Image URL'),
            ),
            TextFormField(
              controller: widget.categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Add Book'),
            ),
          ],
        ),
      ),
    );
  }
}

