import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';
import '../models/cart_item.dart';
import '../models/order.dart' as order_model;

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Book>> getBooks() {
    return _firestore.collection('books').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Book.fromMap(doc.data(), doc.id)).toList(),
    );
  }

  Stream<List<Book>> getBooksByCategory(String category) {
    return _firestore
        .collection('books')
        .where('category', isEqualTo: category)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => Book.fromMap(doc.data(), doc.id)).toList(),
        );
  }

  Stream<List<Book>> searchBooks(String query) {
    return _firestore
        .collection('books')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => Book.fromMap(doc.data(), doc.id)).toList(),
        );
  }

  Future<Book?> getBook(String bookId) async {
    DocumentSnapshot doc = await _firestore.collection('books').doc(bookId).get();
    if (doc.exists) {
      return Book.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Stream<List<CartItem>> getCartItems(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => CartItem.fromMap(doc.data(), doc.id)).toList(),
        );
  }

  Future<void> addToCart(String userId, Book book, int quantity) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(book.id)
        .set(CartItem(id: book.id, book: book, quantity: quantity).toMap());
  }

  Future<void> removeFromCart(String userId, String bookId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(bookId)
        .delete();
  }

  Future<void> clearCart(String userId) async {
    var cartItems = await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();
    for (var doc in cartItems.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> createOrder(String userId, List<CartItem> items, double totalAmount) async {
    order_model.Order order = order_model.Order(
      id: '',
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      orderDate: DateTime.now(),
    );
    await _firestore.collection('orders').add(order.toMap());
    await clearCart(userId);
  }

  Stream<List<order_model.Order>> getOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => order_model.Order.fromMap(doc.data(), doc.id)).toList(),
        );
  }
}
