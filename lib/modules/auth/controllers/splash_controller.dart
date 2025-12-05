import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.toNamed(Routes.ADMIN_BOTTOM_NAV);
  }
}