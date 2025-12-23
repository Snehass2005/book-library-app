import 'package:book_library_app/shared/models/book_model.dart';
import 'package:flutter/material.dart';

class BookForm extends StatefulWidget {
  final Future<void> Function(BookModel) onSubmit;

  const BookForm({super.key, required this.onSubmit});

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _coverUrlController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final book = BookModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
        coverUrl: _coverUrlController.text.trim(),
        category: _categoryController.text.trim().isEmpty
            ? 'Uncategorized' // ✅ fallback if empty
            : _categoryController.text.trim(),
        createdAt: DateTime.now(), // ✅ capture current time
      );

      await widget.onSubmit(book);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
              value == null || value.isEmpty ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author'),
              validator: (value) =>
              value == null || value.isEmpty ? 'Please enter an author' : null,
            ),
            const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
            validator: (value) =>
            value == null || value.trim().isEmpty ? 'Please enter a description' : null,
          ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _coverUrlController,
              decoration: const InputDecoration(labelText: 'Cover Image URL'),
              validator: (value) =>
              value == null || value.trim().isEmpty ? 'Please enter a cover image URL' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) =>
              value == null || value.trim().isEmpty ? 'Please enter a category' : null,
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