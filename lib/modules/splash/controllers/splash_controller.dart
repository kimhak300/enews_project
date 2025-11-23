import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newshub/app/routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isLoggedIn = prefs.containsKey('userId');

      print(isLoggedIn);

      if (isLoggedIn) {
        Get.offAllNamed(Routes.BOTTOM_NAV);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      print('Navigation error: $e');
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}