import 'package:flutter/material.dart';
import 'package:newshub/app/constants/app_colors.dart';
import 'package:newshub/app/theme/theme_constant/text_theme.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    background: AppColors.background,
    surface: AppColors.surface,
    error: AppColors.danger,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: AppColors.textPrimary,
    onSurface: AppColors.textPrimary,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  textTheme: AppTextTheme.lightTextTheme,
  cardTheme: CardThemeData(
    color: AppColors.surface,
    shadowColor: AppColors.shadow,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.grey100,
    hintStyle: const TextStyle(color: AppColors.grey500),
    labelStyle: const TextStyle(color: AppColors.grey700),
    prefixIconColor: AppColors.textPrimary.withOpacity(0.6),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.border),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.grey600,
  ),
);