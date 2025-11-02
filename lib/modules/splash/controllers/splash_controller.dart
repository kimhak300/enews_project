import 'package:get/get.dart';
import '../../../app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      // ignore: avoid_print
      print('Navigation error: $e');
    }
  }
}
