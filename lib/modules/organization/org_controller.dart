import 'package:get/get.dart';
import 'package:newshub/modules/organization/org_home/org_home_view.dart';
import 'package:newshub/modules/organization/org_manage_article/org_manage_article_view.dart';
import 'package:newshub/modules/organization/org_category/org_category_view.dart';
import 'package:newshub/modules/organization/org_report/org_report_view.dart';
import 'package:newshub/modules/organization/org_team/org_team_view.dart';

class OrgController extends GetxController {

  var currentIndex = 0.obs;

    final pages = [
    OrgHomeView(),
    OrgManageArticleView(),
    OrgTeamView(),
    OrgReportView(),
    // show organization categories management in the last tab
    // (uses admin-style UI)
    OrgCategoryView(),
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }
}