import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_pages.dart';
import '../auth_service.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  final _authService = AuthService();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'.tr);
    return emailRegex.hasMatch(email);
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    final token = await _authService.getToken();
    return token != null;
  }

  // ===================================
  // 🔹 LOGIN PROCESS (API + LOCAL)
  // ===================================
  Future<void> login({required String email, required String password}) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password;

    // Basic validation
    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      _showError('please_fill_in_all_fields'.tr);
      return;
    }

    if (!_validateEmail(trimmedEmail)) {
      _showError('please_enter_a_valid_email_address'.tr);
      return;
    }

    isLoading.value = true;

    try {
      // 🔹 1. Try login via DummyJSON API
      final apiResponse = await _authService.login(trimmedEmail, trimmedPassword);

      // 🔹 2. Fetch user profile using token
      final profile = await _fetchUserProfile();
      if (profile != null) {
        // Save profile locally if needed
        _authService.saveCurrentUser(profile);
      }

      _showSuccess('welcome_back ${apiResponse['username'.tr]}!'.tr);
      _navigateToHome();

    } catch (e) {
      // 🔹 3. If API login fails, fallback to local validation
      final localUser = _authService.validateLogin(
        email: trimmedEmail,
        password: trimmedPassword,
      );

      if (localUser != null) {
        _authService.saveCurrentUser(localUser);
        _showSuccess('welcome_back'.tr);
        _navigateToHome();
      } else {
        // 🔹 4. If neither works → show error
  if (_authService.emailExists(trimmedEmail)) {
          _showError('incorrect_password'.tr);
        } else {
          _showError('account_not_found'.tr);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ===================================
  // 🔹 Fetch user profile from API
  // ===================================
  Future<Map<String, dynamic>?> _fetchUserProfile() async {
    try {
      final user = await _authService.getUserProfile();
      print('✅ Current user profile: $user'.tr);
      return user;
    } catch (e) {
      print('⚠️ Failed to fetch profile: $e'.tr);
      return null;
    }
  }

  // ===================================
  // 🔹 refreshToken
  // ===================================

void tryRefresh() async {
  try {
    final newToken = await _authService.refreshToken();
    print('New access token: $newToken'.tr);
  } catch (e) {
    print('Failed to refresh token: $e'.tr);
  }
}


  // ===================================
  // 🔹 Helpers
  // ===================================

  void _showError(String message) {
    Get.snackbar(
      'error'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[400],
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'success'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[400],
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 400));
    Get.offAllNamed(Routes.HOME);
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void goToForgotPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }
}
