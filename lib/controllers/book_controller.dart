import 'package:flutter/foundation.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookController extends ChangeNotifier {
  final BookService _bookService = BookService();
  List<Book> _books = [];
  String? _error;
  bool _isLoading = false;

  List<Book> get books => _books;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Get all books
  Future<void> loadBooks() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _books = await _bookService.getAllBooks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new book
  Future<void> addBook(Book book) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _bookService.addBook(book);
      await loadBooks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get book by ID
  Future<Book?> getBookById(int id) async {
    try {
      return await _bookService.getBookById(id);
    } catch (e) {
      _error = 'Failed to get book';
      notifyListeners();
      return null;
    }
  }

  // Update a book
  Future<bool> updateBook(int id, Book book) async {  // Changed from String to int
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _bookService.updateBook(id, book);
      if (success) {
        await loadBooks();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a book
  Future<bool> deleteBook(int id) async {  // Changed from String to int
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _bookService.deleteBook(id);
      if (success) {
        await loadBooks();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 