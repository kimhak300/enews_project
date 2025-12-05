import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/organization/org_binding.dart';
import 'package:newshub/modules/organization/org_bottom_nav.dart';
import 'package:newshub/modules/organization/org_home/org_home_view.dart';
import 'package:newshub/modules/organization/org_manage_article/org_manage_article_view.dart';
import 'package:newshub/modules/organization/org_profile/org_profile_view.dart';
import 'package:newshub/modules/organization/org_report/org_report_view.dart';
import 'package:newshub/modules/organization/org_team/org_team_view.dart';

class OrgPages {

  static final pages = [
    GetPage(
        name: Routes.ORG_BOTTOM_NAV,
        page: () => OrgBottomNav(),
        binding: OrgBinding()
    ),
    GetPage(
        name: Routes.ORG_HOME,
        page: () => OrgHomeView(),
        binding: OrgBinding()
    ),
    GetPage(
        name: Routes.ORG_MANAGE_ARTICLE,
        page: () => OrgManageArticleView(),
        binding: OrgBinding()
    ),
    GetPage(
        name: Routes.ORG_TEAM,
        page: () => OrgTeamView(),
        binding: OrgBinding()
    ),
    GetPage(
        name: Routes.ORG_REPORT,
        page: () => OrgReportView(),
        binding: OrgBinding()
    ),
    GetPage(
        name: Routes.ORG_PROFILE,
        page: () => OrgProfileView(),
        binding: OrgBinding()
    ),
  ];
}