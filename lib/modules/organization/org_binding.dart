import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart' as api_cat;
import 'package:newshub/modules/organization/org_controller.dart';
import 'package:newshub/modules/organization/org_home/org_home_controller.dart';
import 'package:newshub/modules/organization/org_manage_article/org_manage_article_controller.dart';
import 'package:newshub/modules/organization/org_category/org_category_controller.dart';
import 'package:newshub/modules/organization/org_report/org_report_controller.dart';
import 'package:newshub/modules/organization/org_team/org_team_controller.dart';

class OrgBinding extends Bindings {

  @override
  void dependencies() {
    // Register API CategoryController for article creation
    Get.lazyPut<api_cat.CategoryController>(() => api_cat.CategoryController(), fenix: true);
    
    Get.lazyPut<OrgController>(() => OrgController(), fenix: true);
    Get.lazyPut<OrgHomeController>(() => OrgHomeController(), fenix: true);
    Get.lazyPut<OrgManageArticleController>(() => OrgManageArticleController(), fenix: true);
    Get.lazyPut<OrgTeamController>(() => OrgTeamController(), fenix: true);
    Get.lazyPut<OrgReportController>(() => OrgReportController(), fenix: true);
    Get.lazyPut<OrgProfileController>(() => OrgProfileController(), fenix: true);
  }

}