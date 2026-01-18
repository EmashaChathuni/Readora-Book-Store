import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/book.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class CartProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> fetchCart() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      _firestoreService.getCartItems(userId).listen((items) {
        _items = items;
        notifyListeners();
      });
    }
  }

  Future<void> addItem(Book book, int quantity) async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      await _firestoreService.addToCart(userId, book, quantity);
      notifyListeners();
    }
  }

  Future<void> removeItem(String bookId) async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      await _firestoreService.removeFromCart(userId, bookId);
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      await _firestoreService.clearCart(userId);
      _items.clear();
      notifyListeners();
    }
  }
}
