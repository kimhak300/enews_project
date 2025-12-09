import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart' as api_cat;
import 'package:newshub/modules/admin/admin_controller.dart';
import 'package:newshub/modules/admin/analytics_view/analytics_controller.dart';
import 'package:newshub/modules/admin/dashboard/dashboard_controller.dart';
import 'package:newshub/modules/admin/manage_articles/manage_articles_controller.dart';
import 'package:newshub/modules/admin/manage_categories/manage_categories_controller.dart';
import 'package:newshub/modules/admin/manage_user/manage_users_controller.dart';

class AdminBinding extends Bindings {

  @override
  void dependencies() {
    // Register API CategoryController for article creation
    Get.lazyPut<api_cat.CategoryController>(() => api_cat.CategoryController(), fenix: true);
    
    Get.lazyPut(() => AdminController());
    Get.lazyPut(() => AnalyticsController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => ManageArticlesController());
    Get.lazyPut(() => ManageCategoriesController());
    Get.lazyPut(() => ManageUsersController());
  }

}