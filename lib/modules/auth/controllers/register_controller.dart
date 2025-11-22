import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import '../auth_service.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  final _authService = AuthService();

  @override
  // ignore: unnecessary_overrides
  void onClose() {
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'please_fill_in_all_fields'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    if (name.length < 3) {
      Get.snackbar(
        'error'.tr,
        'name_must_be_at_least_3_characters'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    if (!_validateEmail(email)) {
      Get.snackbar(
        'error'.tr,
        'please_enter_a_valid_email_address'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'error'.tr,
        'password_must_be_at_least_6_characters'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if email already exists
    if (_authService.emailExists(email)) {
      isLoading.value = false;
      Get.snackbar(
        'error'.tr,
        'email_already_registered._please_login_instead.'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[400],
        colorText: Colors.white,
        icon: const Icon(Icons.warning_outlined, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Register user
    final success = _authService.registerUser(
      name: name,
      email: email,
      password: password,
    );

    isLoading.value = false;

    if (success) {
      // Clear fields
      nameController.clear();
      emailController.clear();
      passwordController.clear();

      Get.snackbar(
        'success'.tr,
        'account_created_successfully!_please_login.'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );

      // Navigate to login
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  void goToLogin() {
    Get.back();
  }
}
