import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/auth/services/register_service.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  var isLoading = false.obs;

  final RegisterService _service = RegisterService();
  final GetStorage _storage = GetStorage();
  static const String TOKEN_KEY = 'auth_token';
  static const String ROLE_KEY = 'user_role';

  void register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();

    if (email.isEmpty || password.isEmpty || fullName.isEmpty || phone.isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      final response = await _service.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );

      final token = response['token']?.toString();
      final role = response['user']?['role_status']?.toString().toLowerCase() ?? 'user';

      if (token != null) {
        await _storage.write(TOKEN_KEY, token);
        await _storage.write(ROLE_KEY, role);
      }

      Get.snackbar('Success', 'Register successful',
          snackPosition: SnackPosition.BOTTOM);

      // Navigate to USER_BOTTOM_NAV
      Get.offAllNamed(Routes.USER_BOTTOM_NAV);

    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}