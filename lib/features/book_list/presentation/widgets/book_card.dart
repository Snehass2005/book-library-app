
import 'package:book_library_app/shared/models/book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final double? progressPercentage;
  final String currentUserId; // ✅ Add this

  const BookCard({
    super.key,
    required this.book,
    required this.currentUserId,
    this.progressPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => context.push('/book-details', extra: book),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.network(
                book.coverUrl,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title, style: Theme.of(context).textTheme.titleMedium),
                    Text(book.author, style: Theme.of(context).textTheme.bodySmall),
                    if (progressPercentage != null) ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressPercentage! / 100,
                        backgroundColor: Colors.grey[300],
                        color: Colors.blueAccent,
                      ),
                      Text('${progressPercentage!.toStringAsFixed(1)}% completed',
                          style: Theme.of(context).textTheme.labelSmall),
                    ],
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/reading-progress', extra: {
                          'bookId': book.id,
                          'userId': currentUserId,
                        });
                      },
                      child: const Text('View Reading Progress'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}