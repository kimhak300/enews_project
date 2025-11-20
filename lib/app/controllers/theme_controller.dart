import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../services/theme_service.dart';
import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';

class ThemeController extends GetxController {
  final ThemeService _service = ThemeService();

  var isDarkMode = false.obs;

  ThemeData get theme => isDarkMode.value ? darkTheme : lightTheme;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  void loadTheme() async {
    isDarkMode.value = await _service.getTheme();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _service.saveTheme(isDarkMode.value);
    // Update app ThemeMode so every screen responds instantly
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void setDarkMode(bool value) {
    if (isDarkMode.value == value) return;
    isDarkMode.value = value;
    _service.saveTheme(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
