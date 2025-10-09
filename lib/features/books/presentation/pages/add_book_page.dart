import 'package:book_library_app/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:book_library_app/features/books/presentation/pages/book_details_page.dart';
import 'package:book_library_app/features/books/data/models/book_model.dart';

class AddBookPage extends StatelessWidget {
  const AddBookPage({Key? key}) : super(key: key);
  final List<String> categories = const ["Popular", "Art", "Business", "Craft", "Design", "Science"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Menu"),
          backgroundColor: const Color(0xFF2D52FF),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories.map((cat) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildBookTile(context, "Scrum Master", "Josh Dows", "Management"),
                _buildBookTile(context, "Be a Copywriter", "Yusuf Nugraha", "Communication"),
                _buildBookTile(context, "Product Design 5.0", "Parangeni", "Design"),
                _buildBookTile(context, "Wooden Crafting", "Arvian", "Science"),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBookTile(BuildContext context, String title, String author, String category) {
    final book = Book(
      id: DateTime.now().toString(),
      title: title,
      author: author,
      rating: 4.0,
      description: "This is a description of the book $title in $category category.",
      coverUrl: null,
    );

    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      leading: Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("$category · $author"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailsPage(book: book),
          ),
        );
      },
    );
  }

}
