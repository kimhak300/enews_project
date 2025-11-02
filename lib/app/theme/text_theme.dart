import 'package:flutter/material.dart';
import 'package:newshub/app/theme/app_colors.dart';
import '../../core/constants/app_font_size.dart';

class AppTextTheme {

  // Light TextTheme
  static final TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: AppFontSize.displayLarge, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary),
    displayMedium: TextStyle(fontSize: AppFontSize.displayMedium, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary),
    displaySmall: TextStyle(fontSize: AppFontSize.displaySmall, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary),

    headlineLarge: TextStyle(fontSize: AppFontSize.headlineLarge, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary),
    headlineMedium: TextStyle(fontSize: AppFontSize.headlineMedium, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary),
    headlineSmall: TextStyle(fontSize: AppFontSize.headlineSmall, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary),

    titleLarge: TextStyle(fontSize: AppFontSize.titleLarge, fontWeight: FontWeight.w500, color: AppColors.lightTextPrimary),
    titleMedium: TextStyle(fontSize: AppFontSize.titleMedium, fontWeight: FontWeight.w500, color: AppColors.lightTextPrimary),
    titleSmall: TextStyle(fontSize: AppFontSize.titleSmall, fontWeight: FontWeight.w500, color: AppColors.lightTextPrimary),

    bodyLarge: TextStyle(fontSize: AppFontSize.bodyLarge, fontWeight: FontWeight.normal, color: AppColors.lightTextPrimary),
    bodyMedium: TextStyle(fontSize: AppFontSize.bodyMedium, fontWeight: FontWeight.normal, color: AppColors.lightTextSecondary),
    bodySmall: TextStyle(fontSize: AppFontSize.bodySmall, fontWeight: FontWeight.normal, color: AppColors.lightTextSecondary),

    labelLarge: TextStyle(fontSize: AppFontSize.labelLarge, fontWeight: FontWeight.w500, color: AppColors.lightTextPrimary),
    labelMedium: TextStyle(fontSize: AppFontSize.labelMedium, fontWeight: FontWeight.w500, color: AppColors.lightTextPrimary),
    labelSmall: TextStyle(fontSize: AppFontSize.labelSmall, fontWeight: FontWeight.w500, color: AppColors.lightTextPrimary),
  );

  // Dark TextTheme
  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: AppFontSize.displayLarge, fontWeight: FontWeight.bold, color: AppColors.darkTextPrimary),
    displayMedium: TextStyle(fontSize: AppFontSize.displayMedium, fontWeight: FontWeight.bold, color: AppColors.darkTextPrimary),
    displaySmall: TextStyle(fontSize: AppFontSize.displaySmall, fontWeight: FontWeight.bold, color: AppColors.darkTextPrimary),

    headlineLarge: TextStyle(fontSize: AppFontSize.headlineLarge, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
    headlineMedium: TextStyle(fontSize: AppFontSize.headlineMedium, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
    headlineSmall: TextStyle(fontSize: AppFontSize.headlineSmall, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),

    titleLarge: TextStyle(fontSize: AppFontSize.titleLarge, fontWeight: FontWeight.w500, color: AppColors.darkTextPrimary),
    titleMedium: TextStyle(fontSize: AppFontSize.titleMedium, fontWeight: FontWeight.w500, color: AppColors.darkTextPrimary),
    titleSmall: TextStyle(fontSize: AppFontSize.titleSmall, fontWeight: FontWeight.w500, color: AppColors.darkTextPrimary),

    bodyLarge: TextStyle(fontSize: AppFontSize.bodyLarge, fontWeight: FontWeight.normal, color: AppColors.darkTextPrimary),
    bodyMedium: TextStyle(fontSize: AppFontSize.bodyMedium, fontWeight: FontWeight.normal, color: AppColors.darkTextSecondary),
    bodySmall: TextStyle(fontSize: AppFontSize.bodySmall, fontWeight: FontWeight.normal, color: AppColors.darkTextSecondary),

    labelLarge: TextStyle(fontSize: AppFontSize.labelLarge, fontWeight: FontWeight.w500, color: AppColors.darkTextPrimary),
    labelMedium: TextStyle(fontSize: AppFontSize.labelMedium, fontWeight: FontWeight.w500, color: AppColors.darkTextPrimary),
    labelSmall: TextStyle(fontSize: AppFontSize.labelSmall, fontWeight: FontWeight.w500, color: AppColors.darkTextPrimary),
  );
}