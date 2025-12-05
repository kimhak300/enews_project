import 'package:get/get.dart';
import 'package:newshub/modules/admin/analytics_view/analytics_view.dart';
import 'package:newshub/modules/admin/dashboard/dashboard_binding.dart';
import 'package:newshub/modules/admin/dashboard/dashboard_view.dart';
import 'package:newshub/modules/admin/manage_articles/manage_articles_view.dart';
import 'package:newshub/modules/admin/manage_categories/manage_categories_view.dart';
import 'package:newshub/modules/admin/manage_user/manage_users_view.dart';

class AdminController extends GetxController {

  var currentIndex = 0.obs;

  final pages = [
    DashboardView(),
    ManageUsersView(),
    ManageArticlesView(),
    ManageCategoriesView(),
    AnalyticsView(),
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }

  // Optional: Lazy load controllers per tab
  void initControllers() {
    // Get.lazyPut(() => HomeController());
    // Get.lazyPut(() => CategoryController());
    // Get.lazyPut(() => ProfileController());
  }

  @override
  void onInit() {
    super.onInit();
    initControllers();
  }
}