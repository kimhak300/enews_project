import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:newshub/app/routes/app_routes.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  final AuthService _authService = AuthService();
  final GetStorage _storage = GetStorage();

  // ─────────────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────────────
  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return;
    }

    try {
      isLoading.value = true;

      final response =
      await _authService.login(email: email, password: password);

      final user = response['user'];
      final role = user['role']?.toString().toLowerCase(); // updated role
      final token = response['token']?.toString();

      if (token != null && role != null) {
        await _storage.write(AppConstants.TOKEN_KEY, token);
        await _storage.write(AppConstants.ROLE_KEY, role);
      }

      _navigateByRole(role);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────────
  void logout() async {
    try {
      isLoading.value = true;

      await _authService.logout();

      await _storage.remove(AppConstants.TOKEN_KEY);
      await _storage.remove(AppConstants.ROLE_KEY);

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

  bool isLoggedIn() {
    final token = _storage.read(AppConstants.TOKEN_KEY);
    final role = _storage.read(AppConstants.ROLE_KEY);
    return token != null &&
        token.isNotEmpty &&
        role != null &&
        role.isNotEmpty;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}