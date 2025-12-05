import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:newshub/app/routes/app_routes.dart';

class SplashController extends GetxController {
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 1));

    final token = _storage.read(AppConstants.TOKEN_KEY);
    final role = _storage.read(AppConstants.ROLE_KEY)?.toString().toLowerCase();

    if (token != null && token.isNotEmpty && role != null && role.isNotEmpty) {
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
          Get.offAllNamed(Routes.LOGIN);
      }
    } else {
      Get.offAllNamed(Routes.ADMIN_BOTTOM_NAV);
    }
  }
}