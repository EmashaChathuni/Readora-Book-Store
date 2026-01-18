class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final double price;
  final String coverImage;
  final String category;
  final double rating;
  final String? titleEnglish;
  final String? authorEnglish;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.price,
    required this.coverImage,
    required this.category,
    this.rating = 0.0,
    this.titleEnglish,
    this.authorEnglish,
  });

  factory Book.fromMap(Map<String, dynamic> map, String id) {
    return Book(
      id: id,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      coverImage: map['coverImage'] ?? '',
      category: map['category'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      titleEnglish: map['titleEnglish'],
      authorEnglish: map['authorEnglish'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'coverImage': coverImage,
      'category': category,
      'rating': rating,
      'titleEnglish': titleEnglish,
      'authorEnglish': authorEnglish,
    };
  }
}
