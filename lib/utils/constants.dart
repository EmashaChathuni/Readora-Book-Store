import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  // Modern dark brown/golden color scheme - like sophisticated bookstore
  static const Color primaryBrown = Color(0xFF5D4037); // Dark brown
  static const Color secondaryBrown = Color(0xFF8B6914);
  static const Color lightBrown = Color(0xFFBCAAA4); // Light brown
  static const Color accentGold = Color(0xFFFFB300); // Bright gold
  static const Color backgroundDark = Color(0xFF3E2723); // Very dark brown background
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color textLight = Colors.white; // White text on dark backgrounds
  static const Color textDark = Colors.black87; // Black text on light backgrounds
  static const Color cardBrown = Color(0xFF6D4C41); // Medium brown for cards
  static const Color cardBackground = Color(0xFF4E342E); // Dark brown card background
  static const Color buttonGold = Color(0xFFFFB300); // Bright gold for buttons
  static const Color ratingGold = Color(0xFFFFD700);
  static const Color inputBackground = Color(0xFFF5F5F5); // Light gray for input fields
  static const Color inputText = Colors.black87; // Black text in inputs
}

class AppConstants {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return 'Rs. ${formatter.format(amount)}';
  }
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBrown,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryBrown,
        secondary: AppColors.accentGold,
        surface: AppColors.cardBrown,
        background: AppColors.backgroundDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBrown,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonGold,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
