import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF667EEA);
  static const Color secondary = Color(0xFF764BA2);
  static const Color accent = Color(0xFF4FACFE);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  
  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFB8C00);
  static const Color info = Color(0xFF1E88E5);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Light Theme Colors
  static const lightBackground = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF5F5F5);
  static const lightTextPrimary = Color(0xFF212121);
  static const lightTextSecondary = Color(0xFF757575);

  // Dark Theme Colors
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFFB0B0B0);
}
