import 'package:get/get.dart';
import 'package:newshub/modules/organization/org_home/org_home_view.dart';
import 'package:newshub/modules/organization/org_manage_article/org_manage_article_view.dart';
import 'package:newshub/modules/organization/org_profile/org_profile_view.dart';
import 'package:newshub/modules/organization/org_report/org_report_view.dart';
import 'package:newshub/modules/organization/org_team/org_team_view.dart';

class OrgController extends GetxController {

  var currentIndex = 0.obs;

  final pages = [
    OrgHomeView(),
    OrgManageArticleView(),
    OrgTeamView(),
    OrgReportView(),
    OrgProfileView(),
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }
}