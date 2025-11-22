import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/controllers/theme_controller.dart';

class SettingsController extends GetxController {
  final ThemeController _themeController = Get.find<ThemeController>();

  // Notification toggles
  final pushNotifications = true.obs;
  final emailNotifications = false.obs;

  // Dark mode toggle
  final darkMode = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize darkMode from ThemeController
    darkMode.value = _themeController.themeMode.value == ThemeMode.dark;

    // Keep darkMode in sync with ThemeController
    ever<ThemeMode>(_themeController.themeMode, (mode) {
      darkMode.value = mode == ThemeMode.dark;
    });
  }

  // ---------------- NOTIFICATION ----------------
  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
  }

  void toggleEmailNotifications(bool value) {
    emailNotifications.value = value;
  }

  // ---------------- DARK MODE ----------------
  // void toggleDarkMode(bool value) {
  //   darkMode.value = value;
  //
  //   // Update ThemeController
  //   if (value) {
  //     _themeController.themeMode.value = ThemeMode.dark;
  //     _themeController.saveTheme(true);
  //   } else {
  //     _themeController.themeMode.value = ThemeMode.light;
  //     _themeController.saveTheme(false);
  //   }
  // }
}