import 'package:flutter/material.dart';
import 'package:newshub/app/constants/app_colors.dart';
import 'package:newshub/app/constants/app_font_size.dart';

class AppTextTheme {

  /// LIGHT TEXT THEME
  static final TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: AppFontSize.displayLarge,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: AppFontSize.displayMedium,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: AppFontSize.displaySmall,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),

    headlineLarge: TextStyle(
      fontSize: AppFontSize.headlineLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: AppFontSize.headlineMedium,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: AppFontSize.headlineSmall,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),

    titleLarge: TextStyle(
      fontSize: AppFontSize.titleLarge,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: AppFontSize.titleMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: AppFontSize.titleSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),

    bodyLarge: TextStyle(
      fontSize: AppFontSize.bodyLarge,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: AppFontSize.bodyMedium,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: AppFontSize.bodySmall,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),

    labelLarge: TextStyle(
      fontSize: AppFontSize.labelLarge,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: AppFontSize.labelMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    labelSmall: TextStyle(
      fontSize: AppFontSize.labelSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
  );

  /// DARK TEXT THEME
  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: AppFontSize.displayLarge,
      fontWeight: FontWeight.bold,
      color: AppColors.textLight,
    ),
    displayMedium: TextStyle(
      fontSize: AppFontSize.displayMedium,
      fontWeight: FontWeight.bold,
      color: AppColors.textLight,
    ),
    displaySmall: TextStyle(
      fontSize: AppFontSize.displaySmall,
      fontWeight: FontWeight.bold,
      color: AppColors.textLight,
    ),

    headlineLarge: TextStyle(
      fontSize: AppFontSize.headlineLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight,
    ),
    headlineMedium: TextStyle(
      fontSize: AppFontSize.headlineMedium,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight,
    ),
    headlineSmall: TextStyle(
      fontSize: AppFontSize.headlineSmall,
      fontWeight: FontWeight.w600,
      color: AppColors.textLight,
    ),

    titleLarge: TextStyle(
      fontSize: AppFontSize.titleLarge,
      fontWeight: FontWeight.w500,
      color: AppColors.textLight,
    ),
    titleMedium: TextStyle(
      fontSize: AppFontSize.titleMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.textLight,
    ),
    titleSmall: TextStyle(
      fontSize: AppFontSize.titleSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.textLight,
    ),

    bodyLarge: TextStyle(
      fontSize: AppFontSize.bodyLarge,
      fontWeight: FontWeight.normal,
      color: AppColors.textLight,
    ),
    bodyMedium: TextStyle(
      fontSize: AppFontSize.bodyMedium,
      fontWeight: FontWeight.normal,
      color: AppColors.grey300,   // softer text for dark mode
    ),
    bodySmall: TextStyle(
      fontSize: AppFontSize.bodySmall,
      fontWeight: FontWeight.normal,
      color: AppColors.grey400,
    ),

    labelLarge: TextStyle(
      fontSize: AppFontSize.labelLarge,
      fontWeight: FontWeight.w500,
      color: AppColors.textLight,
    ),
    labelMedium: TextStyle(
      fontSize: AppFontSize.labelMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.textLight,
    ),
    labelSmall: TextStyle(
      fontSize: AppFontSize.labelSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.textLight,
    ),
  );
}