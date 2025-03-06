import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  // Base URL for the API
  final String baseUrl = 'https://library-management-system-wxq8.onrender.com/books';

  // Get all books
  Future<List<Book>> getAllBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: {'accept': 'application/json'}
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Book.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  // Get book by ID
  Future<Book?> getBookById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'accept': 'application/json'}
      );
      if (response.statusCode == 200) {
        return Book.fromMap(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get book: $e');
    }
  }

  // Add a new book
  Future<void> addBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: json.encode(book.toMap()),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add book');
      }
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  // Update a book
  Future<bool> updateBook(int id, Book book) async {
    try {
      final response = await http.put(  
        Uri.parse('$baseUrl/$id'),      
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: json.encode(book.toMap()),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }

  // Delete a book
  Future<bool> deleteBook(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'accept': 'application/json'}
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }
} 