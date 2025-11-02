import 'package:get/get.dart';

class AboutController extends GetxController {
  final appVersion = '1.0.0'.obs;

  void openTermsOfService() {
    Get.snackbar(
      'Terms of Service',
      'Opening Terms of Service...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openPrivacyPolicy() {
    Get.snackbar(
      'Privacy Policy',
      'Opening Privacy Policy...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void contactSupport() {
    Get.snackbar(
      'Support',
      'Opening support email...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openFAQ() {
    Get.snackbar(
      'FAQ',
      'Opening FAQ...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void rateApp() {
    Get.snackbar(
      'Rate App',
      'Thank you for your feedback!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
