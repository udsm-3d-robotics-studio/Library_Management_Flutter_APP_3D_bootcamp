import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookForm extends StatefulWidget {
  final String? initialTitle;
  final String? initialAuthor;
  final String? initialIsbn;
  final int? initialPublishedYear;
  final void Function(String title, String author, String isbn, int publishedYear) onSubmit;

  const BookForm({
    super.key,
    this.initialTitle,
    this.initialAuthor,
    this.initialIsbn,
    this.initialPublishedYear,
    required this.onSubmit,
  });

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _isbnController;
  late final TextEditingController _publishedYearController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _authorController = TextEditingController(text: widget.initialAuthor);
    _isbnController = TextEditingController(text: widget.initialIsbn);
    _publishedYearController = TextEditingController(
      text: widget.initialPublishedYear?.toString() ?? ''
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _publishedYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.initialTitle == null ? 'Add Book' : 'Edit Book',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Author',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an author';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isbnController,
              decoration: const InputDecoration(
                labelText: 'ISBN',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an ISBN';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _publishedYearController,
              decoration: const InputDecoration(
                labelText: 'Published Year',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a published year';
                }
                final year = int.tryParse(value);
                if (year == null || year < 1000 || year > 9999) {
                  return 'Please enter a valid year';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit(
                        _titleController.text,
                        _authorController.text,
                        _isbnController.text,
                        int.parse(_publishedYearController.text),
                      );
                    }
                  },
                  child: Text(
                    widget.initialTitle == null ? 'Add' : 'Save',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 