import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/user/article_detail/user_article_detail_view.dart';
import 'package:newshub/modules/user/article_detail/user_article_detail_binding.dart';
import 'package:newshub/modules/user/bookmark/bookmark_view.dart';
import 'package:newshub/modules/user/home/home_view.dart';
import 'package:newshub/modules/user/profile/profile_view.dart';
import 'package:newshub/modules/user/profile/privacy_settings_view.dart';
import 'package:newshub/modules/user/profile/privacy_settings_binding.dart';
import 'package:newshub/modules/user/profile/about_app_view.dart';
import 'package:newshub/modules/user/profile/about_app_binding.dart';
import 'package:newshub/modules/user/profile/help_support_view.dart';
import 'package:newshub/modules/user/profile/help_support_binding.dart';
import 'package:newshub/modules/user/search/search_view.dart';
import 'package:newshub/modules/user/user_binding.dart';
import 'package:newshub/modules/user/user_bottom_nav.dart';

class UserPages {

  static final pages = [
    GetPage(
        name: Routes.USER_BOTTOM_NAV,
        page: () => UserBottomNav(),
        binding: UserBinding()
    ),
    GetPage(
        name: Routes.USER_HOME,
        page: () => HomeView(),
        binding: UserBinding()
    ),
    GetPage(
        name: Routes.USER_BOOKMARK,
        page: () => BookmarkView(),
        binding: UserBinding()
    ),
    GetPage(
        name: Routes.USER_SEARCH,
        page: () => SearchView(),
        binding: UserBinding()
    ),
    GetPage(
        name: Routes.USER_PROFILE,
        page: () => ProfileView(),
        binding: UserBinding()
    ),
    GetPage(
        name: Routes.PRIVACY_SETTINGS,
        page: () => const PrivacySettingsView(),
        binding: PrivacySettingsBinding()
    ),
    GetPage(
        name: Routes.ABOUT_APP,
        page: () => const AboutAppView(),
        binding: AboutAppBinding()
    ),
    GetPage(
        name: Routes.HELP_SUPPORT,
        page: () => const HelpSupportView(),
        binding: HelpSupportBinding()
    ),
    GetPage(
        name: '/article-detail',
        page: () => const UserArticleDetailView(),
        binding: UserArticleDetailBinding()
    ),
  ];
}