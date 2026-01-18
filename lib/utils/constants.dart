import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  // Modern brown/golden color scheme
  static const Color primaryBrown = Color(0xFFB8860B); // Golden brown
  static const Color secondaryBrown = Color(0xFF8B6914);
  static const Color lightBrown = Color(0xFFD4A76A);
  static const Color accentGold = Color(0xFFDAA520); // Goldenrod
  static const Color backgroundDark = Color(0xFFFAF3E0); // Cream/beige background
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color textLight = Colors.black87; // Black text for visibility
  static const Color textDark = Colors.black87; // Black text for visibility
  static const Color cardBrown = Color(0xFFFFFFFF); // White cards
  static const Color cardBackground = Color(0xFFF5EDD8); // Light cream for cards
  static const Color buttonGold = Color(0xFFB8860B);
  static const Color ratingGold = Color(0xFFFFD700);
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
