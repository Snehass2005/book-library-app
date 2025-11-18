import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookSearchInput extends StatelessWidget {
  final void Function(String) onSearch;

  const BookSearchInput({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearch,
      decoration: InputDecoration(
        hintText: 'Search books...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}