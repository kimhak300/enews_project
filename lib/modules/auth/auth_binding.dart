import 'package:get/get.dart';
import 'package:newshub/modules/auth/controllers/login_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}