import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  final AuthService _authService = AuthService();

  // ─────────────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────────────
  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    final result = await _authService.login(email: email, password: password);

    isLoading.value = false;

    if (!result.success) {
      Get.snackbar('Error', result.error ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    _navigateByRole(result.data!.user.primaryRole.toLowerCase());
  }

  // ─────────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────────
  void logout() async {
    try {
      isLoading.value = true;

      await _authService.logout();

      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // NAVIGATE BY ROLE
  // ─────────────────────────────────────────────
  void _navigateByRole(String? role) {
    switch (role) {
      case 'user':
        Get.offAllNamed(Routes.USER_BOTTOM_NAV);
        break;
      case 'admin':
        Get.offAllNamed(Routes.ADMIN_BOTTOM_NAV);
        break;
      case 'organizer':
        Get.offAllNamed(Routes.ORG_BOTTOM_NAV);
        break;
      default:
        Get.snackbar('Error', 'Unknown role',
            snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<bool> isLoggedIn() {
    return _authService.hasToken();
  }

  void loginWithGoogle() {
    Get.snackbar('Coming soon', 'Google Sign-In will be available after OAuth setup',
        snackPosition: SnackPosition.BOTTOM);
  }

  void loginWithFacebook() {
    Get.snackbar('Coming soon', 'Facebook Login will be available after OAuth setup',
        snackPosition: SnackPosition.BOTTOM);
  }
}