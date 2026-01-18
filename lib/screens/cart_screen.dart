import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _checkout(List<CartItem> items) async {
    setState(() => _isLoading = true);
    try {
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        double total = items.fold(0, (sum, item) => sum + item.totalPrice);
        await _firestoreService.createOrder(userId, items, total);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order placed successfully!'),
              backgroundColor: AppColors.accentGold,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checkout failed'),
            backgroundColor: AppColors.secondaryBrown,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBrown,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: userId == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'Please login to view cart',
                    style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          : StreamBuilder<List<CartItem>>(
              stream: _firestoreService.getCartItems(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.buttonGold),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }
                final items = snapshot.data!;
                double total = items.fold(0, (sum, item) => sum + item.totalPrice);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            color: AppColors.cardBrown,
                            margin: EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 100,
                                    color: AppColors.secondaryBrown,
                                    child: item.book.coverImage.isNotEmpty
                                        ? Image.network(
                                            item.book.coverImage,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Icon(Icons.book, color: AppColors.accentGold),
                                          )
                                        : Icon(Icons.book, color: AppColors.accentGold),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.book.title,
                                          style: TextStyle(
                                            color: AppColors.textLight,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.book.author,
                                          style: TextStyle(color: AppColors.accentGold),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppConstants.formatCurrency(item.totalPrice),
                                              style: TextStyle(
                                                color: AppColors.accentGold,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Qty: ${item.quantity}',
                                              style: TextStyle(color: AppColors.textLight),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: AppColors.accentGold),
                                    onPressed: () async {
                                      await _firestoreService.removeFromCart(userId, item.book.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBrown,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                AppConstants.formatCurrency(total),
                                style: TextStyle(
                                  color: AppColors.accentGold,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          CustomButton(
                            text: 'Checkout',
                            onPressed: () => _checkout(items),
                            isLoading: _isLoading,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
