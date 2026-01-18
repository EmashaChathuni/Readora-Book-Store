import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  int _quantity = 1;
  bool _isLoading = false;

  Future<void> _addToCart() async {
    // Check if user is logged in
    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      // Show modern login dialog
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.cardBrown,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.accentGold, size: 28),
              SizedBox(width: 12),
              Text(
                'Login Required',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Text(
            'Please login to add items to your cart and make purchases',
            style: TextStyle(
              color: AppColors.textLight.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textLight.withOpacity(0.7)),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Login Now',
                style: TextStyle(
                  color: AppColors.backgroundDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      
      if (result == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _firestoreService.addToCart(userId, widget.book, _quantity);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to cart successfully!'),
            backgroundColor: AppColors.accentGold,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add to cart'),
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
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBrown,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: widget.book.coverImage.isNotEmpty
                  ? Image.network(
                      widget.book.coverImage,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.book, size: 100, color: AppColors.buttonGold),
                    )
                  : Icon(Icons.book, size: 100, color: AppColors.buttonGold),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (widget.book.titleEnglish != null) ...[
                    SizedBox(height: 4),
                    Text(
                      widget.book.titleEnglish!,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  SizedBox(height: 8),
                  Text(
                    'by ${widget.book.authorEnglish ?? widget.book.author}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.ratingGold, size: 22),
                      SizedBox(width: 4),
                      Text(
                        widget.book.rating.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.buttonGold, width: 1),
                        ),
                        child: Text(
                          widget.book.category,
                          style: TextStyle(
                            color: AppColors.buttonGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.book.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppConstants.formatCurrency(widget.book.price),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonGold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_quantity > 1) {
                                setState(() => _quantity--);
                              }
                            },
                            icon: Icon(Icons.remove_circle, color: AppColors.accentGold),
                          ),
                          Text(
                            '$_quantity',
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.textLight,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => _quantity++);
                            },
                            icon: Icon(Icons.add_circle, color: AppColors.accentGold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  CustomButton(
                    text: 'Add to Cart',
                    onPressed: _addToCart,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
