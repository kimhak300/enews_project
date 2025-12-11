import 'package:get/get.dart';
import 'package:newshub/modules/user/bookmark/bookmark_controller.dart';
import 'package:newshub/modules/user/home/home_controller.dart';
import 'package:newshub/modules/user/hotnews/hotnews_controller.dart';
import 'package:newshub/modules/user/profile/profile_controller.dart';
import 'package:newshub/modules/user/video/video_controller.dart';
import 'package:newshub/modules/user/user_controller.dart';

class UserBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => VideoController());
    Get.lazyPut(() => HotNewsController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => BookmarkController(), fenix: true);
  }

}