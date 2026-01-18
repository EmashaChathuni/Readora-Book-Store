import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';
import 'profile_screen.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const PaymentScreen({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedPaymentMethod = '';
  bool _isProcessing = false;

  // Card payment fields
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  // Cash on delivery fields
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedPaymentMethod == 'card') {
      if (_cardNumberController.text.isEmpty ||
          _cardHolderController.text.isEmpty ||
          _expiryController.text.isEmpty ||
          _cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill all card details'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      if (_addressController.text.isEmpty || _phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill delivery address and phone number'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Create order
      await _firestoreService.createOrder(
        user.uid,
        widget.cartItems,
        widget.totalAmount,
      );

      // Clear cart
      for (var item in widget.cartItems) {
        await _firestoreService.removeFromCart(user.uid, item.book.id);
      }

      setState(() => _isProcessing = false);

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.cardBrown,
          title: Text(
            'Order Placed Successfully!',
            style: TextStyle(color: AppColors.textLight),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green[300],
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Your order has been placed successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textLight),
              ),
              SizedBox(height: 8),
              Text(
                'Total: ${AppConstants.formatCurrency(widget.totalAmount)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                  (route) => false,
                );
              },
              child: Text(
                'View Orders',
                style: TextStyle(color: AppColors.accentGold),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing payment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('Payment', style: TextStyle(color: AppColors.textLight)),
        backgroundColor: AppColors.primaryBrown,
        iconTheme: IconThemeData(color: AppColors.textLight),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBrown,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.cartItems.length} items',
                        style: TextStyle(color: AppColors.textLight),
                      ),
                      Text(
                        AppConstants.formatCurrency(widget.totalAmount),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentGold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Payment Methods
            Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            SizedBox(height: 16),

            // Card Payment Option
            _buildPaymentMethodCard(
              icon: Icons.credit_card,
              title: 'Card Payment',
              subtitle: 'Pay with Credit/Debit Card',
              value: 'card',
            ),
            SizedBox(height: 12),

            // Cash on Delivery Option
            _buildPaymentMethodCard(
              icon: Icons.money,
              title: 'Cash on Delivery',
              subtitle: 'Pay when you receive',
              value: 'cod',
            ),
            SizedBox(height: 24),

            // Payment Details Form
            if (_selectedPaymentMethod == 'card') ...[
              _buildCardPaymentForm(),
            ] else if (_selectedPaymentMethod == 'cod') ...[
              _buildCodForm(),
            ],

            SizedBox(height: 24),

            // Process Payment Button
            if (_selectedPaymentMethod.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGold,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessing
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.backgroundDark,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.backgroundDark,
                          ),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final bool isSelected = _selectedPaymentMethod == value;

    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBrown,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentGold : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentGold.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.accentGold : AppColors.textLight,
                size: 32,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.accentGold,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPaymentForm() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBrown,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: AppColors.inputText),
            decoration: InputDecoration(
              labelText: 'Card Number',
              labelStyle: TextStyle(color: AppColors.textDark.withOpacity(0.7)),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _cardHolderController,
            style: TextStyle(color: AppColors.inputText),
            decoration: InputDecoration(
              labelText: 'Card Holder Name',
              labelStyle: TextStyle(color: AppColors.textDark.withOpacity(0.7)),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(color: AppColors.inputText),
                  decoration: InputDecoration(
                    labelText: 'MM/YY',
                    labelStyle: TextStyle(color: AppColors.textDark.withOpacity(0.7)),
                    filled: true,
                    fillColor: AppColors.inputBackground,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  style: TextStyle(color: AppColors.inputText),
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    labelStyle: TextStyle(color: AppColors.textDark.withOpacity(0.7)),
                    filled: true,
                    fillColor: AppColors.inputBackground,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodForm() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBrown,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _addressController,
            maxLines: 3,
            style: TextStyle(color: AppColors.inputText),
            decoration: InputDecoration(
              labelText: 'Delivery Address',
              labelStyle: TextStyle(color: AppColors.textDark.withOpacity(0.7)),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: AppColors.inputText),
            decoration: InputDecoration(
              labelText: 'Phone Number',
              labelStyle: TextStyle(color: AppColors.textDark.withOpacity(0.7)),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
