import 'package:get/get.dart';
import '../../app/controllers/theme_controller.dart';

class SettingsController extends GetxController {
  final ThemeController _themeController = Get.find<ThemeController>();
  final pushNotifications = true.obs;
  final emailNotifications = false.obs;
  final darkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize from ThemeController and keep in sync
    darkMode.value = _themeController.isDarkMode.value;
    ever<bool>(_themeController.isDarkMode, (val) => darkMode.value = val);
  }

  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
  }

  void toggleEmailNotifications(bool value) {
    emailNotifications.value = value;
  }

  void toggleDarkMode(bool value) {
    _themeController.setDarkMode(value);
  }
}
