import 'book.dart';

class CartItem {
  final String id;
  final Book book;
  final int quantity;

  CartItem({
    required this.id,
    required this.book,
    required this.quantity,
  });

  double get totalPrice => book.price * quantity;

  factory CartItem.fromMap(Map<String, dynamic> map, String id) {
    return CartItem(
      id: id,
      book: Book.fromMap(map['book'], map['bookId']),
      quantity: map['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': book.id,
      'book': book.toMap(),
      'quantity': quantity,
    };
  }
}
