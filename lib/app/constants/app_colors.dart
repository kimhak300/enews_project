import 'package:flutter/material.dart';

class AppColors {

  /// Main Color
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF004BA0);
  static const Color primaryLight = Color(0xFF63A4FF);

  /// Secondary Color
  static const Color secondary = Color(0xFFFF9800);
  static const Color secondaryDark = Color(0xFFC66900);
  static const Color secondaryLight = Color(0xFFFFC947);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  /// SYSTEM COLORS
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color danger = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  /// BACKGROUND & SURFACE
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF121212);

  /// TEXT COLORS
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF000000);

  /// BORDER / OUTLINE
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFBDBDBD);

  /// GRADIENTS
  static const Gradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF1976D2),
      Color(0xFF63A4FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient secondaryGradient = LinearGradient(
    colors: [
      Color(0xFFFF9800),
      Color(0xFFFFC947),
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  /// Shadow Color
  static Color shadow = Colors.grey.withOpacity(0.2);
}