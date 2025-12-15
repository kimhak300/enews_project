import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/admin/admin_binding.dart';
import 'package:newshub/modules/admin/admin_bottom_nav.dart';
import 'package:newshub/modules/user/user_binding.dart';
import 'package:newshub/modules/user/profile/profile_view.dart';
import 'package:newshub/modules/admin/analytics_view/analytics_view.dart';
import 'package:newshub/modules/admin/dashboard/dashboard_view.dart';
import 'package:newshub/modules/admin/manage_articles/manage_articles_view.dart';
import 'package:newshub/modules/admin/manage_categories/manage_categories_view.dart';
import 'package:newshub/modules/admin/manage_user/manage_users_view.dart';
import 'package:newshub/modules/admin/manage_user/user_detail_view.dart';
import 'package:newshub/modules/admin/manage_user/user_detail_binding.dart';

class AdminPages {

  static final pages = [
    GetPage(
      name: Routes.ADMIN_BOTTOM_NAV,
      page: () => AdminBottomNav(),
      binding: AdminBinding()
    ),
    GetPage(
        name: Routes.ADMIN_ANALYTICS,
        page: () => AnalyticsView(),
        binding: AdminBinding()
    ),
    GetPage(
        name: Routes.ADMIN_DASHBOARD,
        page: () => DashboardView(),
        binding: AdminBinding()
    ),
    GetPage(
        name: Routes.ADMIN_MANAGE_ARTICLE,
        page: () => ManageArticlesView(),
        binding: AdminBinding()
    ),
    GetPage(
        name: Routes.ADMIN_MANAGE_CATEGORY,
        page: () => ManageCategoriesView(),
        binding: AdminBinding()
    ),
    GetPage(
        name: Routes.ADMIN_MANAGE_USER,
        page: () => ManageUsersView(),
        binding: AdminBinding()
    ),
    GetPage(
        name: Routes.ADMIN_USER_DETAIL,
        page: () => UserDetailView(),
        binding: UserDetailBinding()
    ),
    GetPage(
      name: Routes.ADMIN_MANAGER_PROFILE,
      page: () => ProfileView(),
      binding: UserBinding()
    ),
  ];
}