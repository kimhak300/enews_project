import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart' as api_cat;
import 'package:newshub/modules/organization/org_controller.dart';
import 'package:newshub/modules/organization/org_home/org_home_controller.dart';
import 'package:newshub/modules/organization/org_manage_article/org_manage_article_view.dart';
import 'package:newshub/modules/organization/org_profile/org_profile_controller.dart';
import 'package:newshub/modules/organization/org_report/org_report_controller.dart';
import 'package:newshub/modules/organization/org_team/org_team_controller.dart';

class OrgBinding extends Bindings {

  @override
  void dependencies() {
    // Register API CategoryController for article creation
    Get.lazyPut<api_cat.CategoryController>(() => api_cat.CategoryController(), fenix: true);
    
    Get.lazyPut(() => OrgController());
    Get.lazyPut(() => OrgHomeController());
    Get.lazyPut(() => OrgManageArticleView());
    Get.lazyPut(() => OrgTeamController());
    Get.lazyPut(() => OrgReportController());
    Get.lazyPut(() => OrgProfileController());
  }

}