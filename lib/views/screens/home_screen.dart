import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/book_controller.dart';
import '../../models/book.dart';
import '../widgets/book_form.dart';
import '../widgets/book_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      context.read<BookController>().loadBooks()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Library Management'),
        actions: [
          IconButton(
            onPressed: () => _showAddBookDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
        elevation: 2,
      ),
      body: Consumer<BookController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadBooks(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.books.isEmpty) {
            return const Center(
              child: Text('No books available. Add some books!'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.loadBooks(),
            child: ListView.builder(
              itemCount: controller.books.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final book = controller.books[index];
                return BookListItem(
                  book: book,
                  onEdit: () => _showEditBookDialog(context, book),
                  onDelete: () => _deleteBook(context, book),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBookDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBookDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: BookForm(
          onSubmit: (title, author, isbn, publishedYear) {
            final book = Book(
              title: title,
              author: author,
              isbn: isbn,
              publishedYear: publishedYear,
            );
            context.read<BookController>().addBook(book);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showEditBookDialog(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: BookForm(
          initialTitle: book.title,
          initialAuthor: book.author,
          initialIsbn: book.isbn,
          initialPublishedYear: book.publishedYear,
          onSubmit: (title, author, isbn, publishedYear) {
            final updatedBook = Book(
              id: book.id,
              title: title,
              author: author,
              isbn: isbn,
              publishedYear: publishedYear,
            );
            context.read<BookController>().updateBook(book.id!, updatedBook);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _deleteBook(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text('Are you sure you want to delete "${book.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<BookController>().deleteBook(book.id!);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}