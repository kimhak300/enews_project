import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/auth/services/auth_service.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  var isLoading = false.obs;

  final AuthService _authService = AuthService();

  void register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final displayName = fullNameController.text.trim();
    final phone = phoneController.text.trim();

    if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
      Get.snackbar('Error', 'Name, email and password are required',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    final result = await _authService.register(
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
      displayName: displayName,
      phone: phone.isNotEmpty ? phone : null,
    );

    isLoading.value = false;

    if (!result.success) {
      Get.snackbar('Error', result.error ?? 'Registration failed',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Show success and navigate to login
    Get.snackbar('Success', 'Registration successful! Please login to continue.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3));
    
    // Clear form fields
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    fullNameController.clear();
    phoneController.clear();
    
    // Navigate to login after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offAllNamed(Routes.LOGIN);
    });
  }

  void loginWithGoogle() {
    Get.snackbar('Coming soon', 'Google Sign-In will be available after OAuth setup',
        snackPosition: SnackPosition.BOTTOM);
  }

  void loginWithFacebook() {
    Get.snackbar('Coming soon', 'Facebook Login will be available after OAuth setup',
        snackPosition: SnackPosition.BOTTOM);
  }

  void _navigateByRole(String? role) {
    switch (role) {
      case 'admin':
        Get.offAllNamed(Routes.ADMIN_BOTTOM_NAV);
        break;
      case 'organizer':
        Get.offAllNamed(Routes.ORG_BOTTOM_NAV);
        break;
      default:
        Get.offAllNamed(Routes.USER_BOTTOM_NAV);
    }
  }
}