import 'package:flutter/material.dart';
import 'package:newshub/app/theme/app_colors.dart';
import 'package:newshub/app/theme/text_theme.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: AppColors.darkTextPrimary,
    onSurface: AppColors.darkTextPrimary,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: AppColors.darkTextPrimary,
  ),
  textTheme: AppTextTheme.darkTextTheme,
  cardColor: AppColors.darkSurface,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);
