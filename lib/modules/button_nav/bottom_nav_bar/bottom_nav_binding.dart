import 'package:get/get.dart';
import 'package:newshub/modules/p1_home/home_controller.dart';
import 'package:newshub/modules/p4_saved/bookmark_controller.dart';
import '../../../sqflite_db/controller/bookmark_controller.dart';
import 'bottom_nav_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BookmarkController>(() => BookmarkController());
  }
}