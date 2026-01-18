import 'package:flutter/material.dart';
import '../models/order.dart' as order_model;
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBrown,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order History',
          style: TextStyle(color: AppColors.textLight),
        ),
      ),
      body: userId == null
          ? Center(
              child: Text(
                'Please login to view orders',
                style: TextStyle(color: AppColors.accentGold),
              ),
            )
          : StreamBuilder<List<order_model.Order>>(
              stream: _firestoreService.getOrders(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.accentGold),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No orders yet',
                      style: TextStyle(color: AppColors.accentGold, fontSize: 16),
                    ),
                  );
                }
                final orders = snapshot.data!;

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      color: AppColors.cardBrown,
                      margin: EdgeInsets.only(bottom: 16),
                      child: ExpansionTile(
                        title: Text(
                          'Order #${order.id.substring(0, 8)}',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('MMM dd, yyyy - hh:mm a').format(order.orderDate),
                          style: TextStyle(color: AppColors.accentGold),
                        ),
                        trailing: Text(
                          AppConstants.formatCurrency(order.totalAmount),
                          style: TextStyle(
                            color: AppColors.accentGold,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        iconColor: AppColors.accentGold,
                        collapsedIconColor: AppColors.accentGold,
                        children: order.items.map((item) {
                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 70,
                              color: AppColors.secondaryBrown,
                              child: item.book.coverImage.isNotEmpty
                                  ? Image.network(
                                      item.book.coverImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.book, color: AppColors.accentGold, size: 20),
                                    )
                                  : Icon(Icons.book, color: AppColors.accentGold, size: 20),
                            ),
                            title: Text(
                              item.book.title,
                              style: TextStyle(color: AppColors.textLight),
                            ),
                            subtitle: Text(
                              'Qty: ${item.quantity}',
                              style: TextStyle(color: AppColors.accentGold),
                            ),
                            trailing: Text(
                              AppConstants.formatCurrency(item.totalPrice),
                              style: TextStyle(color: AppColors.accentGold),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
