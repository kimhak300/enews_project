import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendResetLink() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error'.tr,
        'Please enter your email'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    Get.back();
    Get.snackbar(
      'Success'.tr,
      'Password reset link sent to your email'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
