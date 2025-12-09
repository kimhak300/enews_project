import 'package:get/get.dart';
import 'package:newshub/modules/auth/controllers/auth_controller.dart';
import 'package:newshub/modules/auth/controllers/splash_controller.dart';
import 'package:newshub/modules/auth/controllers/register_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => RegisterController());
  }
}