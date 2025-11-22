import 'package:get/get.dart';
import 'package:newshub/modules/p2_dashboard/dashboard_controller.dart';
import 'home_controller.dart';
import '../p3_search/search_controller.dart';
import '../p4_saved/bookmark_controller.dart';
import '../p5_profile/controller/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(), permanent: true);
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => SearchController());
    Get.lazyPut(() => BookmarkController());
    Get.lazyPut(() => ProfileController());
  }
}
