import 'package:flutter/material.dart';
import 'package:newshub/app/constants/app_colors.dart';
import 'package:newshub/app/theme/theme_constant/text_theme.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryDark,
    secondary: AppColors.secondaryDark,
    background: AppColors.surfaceDark,
    surface: AppColors.surfaceDark,
    error: AppColors.danger,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: AppColors.textLight,
    onSurface: AppColors.textLight,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.surfaceDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryDark,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  textTheme:
      GoogleFonts.getTextTheme('Kantumruy Pro', AppTextTheme.lightTextTheme),
  cardTheme: CardThemeData(
    color: AppColors.surfaceDark,
    shadowColor: AppColors.shadow,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.surfaceDark,
    selectedItemColor: AppColors.primaryLight,
    unselectedItemColor: AppColors.grey500,
  ),
);
