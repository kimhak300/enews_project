// import 'package:get/get.dart';
// import 'package:newshub/app/routes/app_routes.dart';
// import 'package:newshub/modules/admin/admin_pages.dart';
// import 'package:newshub/modules/auth/auth_binding.dart';
// import 'package:newshub/modules/button_nav/bottom_nav_bar/bottom_nav_binding.dart';
// import 'package:newshub/modules/button_nav/bottom_nav_bar/bottom_nav_view.dart';
// import 'package:newshub/modules/p5_profile/view/about_view.dart';
// import 'package:newshub/modules/p5_profile/view/profile_view.dart';
// import 'package:newshub/modules/p5_profile/view/settings_view.dart';
// import 'package:newshub/modules/p6_post/edit_article/edit_article_binding.dart';
// import 'package:newshub/modules/p6_post/edit_article/edit_article_view.dart';
// import 'package:newshub/modules/p6_post/edit_video/edit_video_binding.dart';
// import 'package:newshub/modules/p6_post/edit_video/edit_video_view.dart';
// import '../../modules/p1_home/home_binding.dart';
// import '../../modules/p1_home/home_view.dart';
// import '../../modules/p3_search/search_binding.dart';
// import '../../modules/p3_search/search_view.dart';
// import '../../modules/p4_saved/bookmark_binding.dart';
// import '../../modules/p4_saved/saved_screen/bookmark_view.dart';
// import '../../modules/p5_profile/binding/about_binding.dart';
// import '../../modules/p5_profile/binding/profile_binding.dart';
// import '../../modules/p5_profile/binding/settings_binding.dart';
// import '../../modules/splash/splash_view.dart';
// import '../../modules/splash/bindings/splash_binding.dart';
// import '../../modules/auth/bindings/forgot_password_binding.dart';
// import '../../modules/p2_dashboard/dashboard_binding.dart';
// import '../../modules/p6_post/edit_post/edit_post_binding.dart';
// import '../../modules/p6_post/edit_post/edit_post_view.dart';
// import '../../modules/auth/views/login_view.dart';
// import '../../modules/auth/views/register_view.dart';
// import '../../modules/auth/views/forgot_password_view.dart';
// import '../../modules/p2_dashboard/dashboard_screen/dashboard_view.dart';
//
// class AppPages {
//
//   static const INITIAL = Routes.SPLASH;
//
//   static final routes = [
//     ...AdminPages.pages,
//
//     GetPage(
//       name: Routes.SPLASH,
//       page: () => SplashView(),
//       binding: SplashBinding(),
//     ),
//     // GetPage(
//     //   name: Routes.LOGIN,
//     //   page: () => LoginView(),
//     //   binding: AuthBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.REGISTER,
//     //   page: () => RegisterView(),
//     //   binding: AuthBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.FORGOT_PASSWORD,
//     //   page: () => const ForgotPasswordView(),
//     //   binding: ForgotPasswordBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.HOME,
//     //   page: () => HomeView(),
//     //   binding: HomeBinding(),
//     //   preventDuplicates: true,
//     //   transition: Transition.fadeIn,
//     // ),
//     // GetPage(
//     //   name: Routes.DASHBOARD,
//     //   page: () => DashboardView(),
//     //   binding: DashboardBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.SEARCH,
//     //   page: () =>  SearchView(),
//     //   binding: SearchBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.BOOKMARK,
//     //   page: () => const BookmarkView(),
//     //   binding: BookmarkBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.PROFILE,
//     //   page: () => ProfileView(),
//     //   binding: ProfileBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.SETTINGS,
//     //   page: () => const SettingsView(),
//     //   binding: SettingsBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.ABOUT,
//     //   page: () => const AboutView(),
//     //   binding: AboutBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.EDIT_POST,
//     //   page: () => const EditPostView(),
//     //   binding: EditPostBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.EDIT_ARTICLE,
//     //   page: () => const EditArticleView(),
//     //   binding: EditArticleBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.EDIT_VIDEO,
//     //   page: () => const EditVideoView(),
//     //   binding: EditVideoBinding(),
//     // ),
//     // GetPage(
//     //   name: Routes.BOTTOM_NAV,
//     //   page: () => BottomNavView(),
//     //   binding: BottomNavBinding(),
//     // ),
//   ];
// }

import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/admin/admin_pages.dart';
import 'package:newshub/modules/splash/bindings/splash_binding.dart';
import 'package:newshub/modules/splash/splash_view.dart';

class AppPages {
  static final pages = [
    // Home Module
    ...AdminPages.pages,

    // Category Module
    // ...CategoryRoutes.pages,
    //
    // // Profile Page
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
