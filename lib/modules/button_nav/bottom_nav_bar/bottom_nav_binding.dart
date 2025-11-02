import 'package:get/get.dart';
import 'package:newshub/modules/button_nav/bottom_nav_bar/bottom_nav_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController());
  }
}