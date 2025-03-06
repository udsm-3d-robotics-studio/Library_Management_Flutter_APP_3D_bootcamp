class Book {
  final int? id;
  final String title;
  final String author;
  final int publishedYear;
  final String isbn;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.publishedYear,
    required this.isbn,
  });

  // Convert Book to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'published_year': publishedYear,
      'isbn': isbn,
    };
  }

  // Create Book from Map
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      publishedYear: map['published_year'],
      isbn: map['isbn'],
    );
  }

  // Create copy of Book with some modified fields
  Book copyWith({
    int? id,
    String? title,
    String? author,
    int? publishedYear,
    String? isbn,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      publishedYear: publishedYear ?? this.publishedYear,
      isbn: isbn ?? this.isbn,
    );
  }
} 