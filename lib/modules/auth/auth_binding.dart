import 'package:get/get.dart';
import 'package:newshub/modules/auth/auth_controller.dart';
import 'package:newshub/modules/auth/controllers/splash_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => SplashController());
  }
}