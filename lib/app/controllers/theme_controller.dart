import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:newshub/app/services/theme_service.dart';

class ThemeController extends GetxController {

  final ThemeService _service = Get.find<ThemeService>();

  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() async {
    bool isDark = await _service.loadTheme();
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      _service.saveTheme(true);
    } else {
      themeMode.value = ThemeMode.light;
      _service.saveTheme(false);
    }
  }
}