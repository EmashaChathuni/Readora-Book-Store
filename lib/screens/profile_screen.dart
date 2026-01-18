import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../utils/constants.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'payment_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: AppColors.textLight)),
        backgroundColor: AppColors.primaryBrown,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textLight),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: user == null
          ? Center(
              child: Text(
                'Please login to view profile',
                style: TextStyle(color: AppColors.textLight, fontSize: 18),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info Card
                  _buildUserInfoCard(user),
                  SizedBox(height: 20),
                  
                  // Quick Actions
                  _buildQuickActions(context),
                  SizedBox(height: 20),
                  
                  // Cart Section
                  _buildCartSection(context, user.uid),
                  SizedBox(height: 20),
                  
                  // Order History Section
                  _buildOrderHistorySection(context, user.uid),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildUserInfoCard(User user) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBrown,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.accentGold,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            user.email ?? 'User',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Member since ${user.metadata.creationTime?.year ?? 'N/A'}',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.shopping_cart,
                  label: 'My Cart',
                  color: AppColors.accentGold,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CartScreen()),
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.history,
                  label: 'Orders',
                  color: AppColors.primaryBrown,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OrdersScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBrown,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSection(BuildContext context, String userId) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Cart',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          SizedBox(height: 12),
          StreamBuilder<List<CartItem>>(
            stream: _firestoreService.getCartItems(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.accentGold),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBrown,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(color: AppColors.textLight.withOpacity(0.7)),
                    ),
                  ),
                );
              }

              final cartItems = snapshot.data!;
              final total = cartItems.fold<double>(
                0,
                (sum, item) => sum + (item.price * item.quantity),
              );

              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBrown,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${cartItems.length} items in cart',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textLight,
                          ),
                        ),
                        Text(
                          AppConstants.formatCurrency(total),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentGold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                cartItems: cartItems,
                                totalAmount: total,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGold,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Proceed to Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.backgroundDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHistorySection(BuildContext context, String userId) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrdersScreen()),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(color: AppColors.accentGold),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          StreamBuilder<List<Order>>(
            stream: _firestoreService.getUserOrders(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.accentGold),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBrown,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'No orders yet',
                      style: TextStyle(color: AppColors.textLight.withOpacity(0.7)),
                    ),
                  ),
                );
              }

              final recentOrders = snapshot.data!.take(3).toList();

              return Column(
                children: recentOrders.map((order) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBrown,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          color: AppColors.accentGold,
                          size: 32,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #${order.id.substring(0, 8)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textLight,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${order.items.length} items',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textLight.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AppConstants.formatCurrency(order.totalAmount),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentGold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              order.status,
                              style: TextStyle(
                                fontSize: 12,
                                color: order.status == 'Completed'
                                    ? Colors.green[300]
                                    : AppColors.textLight.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
