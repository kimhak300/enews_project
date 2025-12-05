import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/admin/admin_pages.dart';
import 'package:newshub/modules/auth/auth_pages.dart';
import 'package:newshub/modules/organization/org_pages.dart';
import 'package:newshub/modules/user/user_pages.dart';

class AppPages {


  static const INITIAL = Routes.SPLASH;

  // static final routes = <GetPage>[
  //   GetPage(
  //     name: _Paths.SPLASH,
  //     page: () => const SplashView(),
  //     binding: SplashBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.LOGIN,
  //     page: () => LoginView(),
  //     binding: LoginBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.REGISTER,
  //     page: () => const RegisterView(),
  //     binding: RegisterBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.FORGOT_PASSWORD,
  //     page: () => const ForgotPasswordView(),
  //     binding: ForgotPasswordBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.HOME,
  //     page: () => HomeView(),
  //     binding: HomeBinding(),
  //     preventDuplicates: true,
  //     transition: Transition.fadeIn,
  //   ),
  //   GetPage(
  //     name: _Paths.DASHBOARD,
  //     page: () => DashboardView(),
  //     binding: DashboardBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.SEARCH,
  //     page: () => const SearchView(),
  //     binding: SearchBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.BOOKMARK,
  //     page: () => const BookmarkView(),
  //     binding: BookmarkBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.PROFILE,
  //     page: () => const ProfileView(),
  //     binding: ProfileBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.SETTINGS,
  //     page: () => const SettingsView(),
  //     binding: SettingsBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.ABOUT,
  //     page: () => const AboutView(),
  //     binding: AboutBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.EDIT_POST,
  //     page: () => const EditPostView(),
  //     binding: EditPostBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.EDIT_ARTICLE,
  //     page: () => const EditArticleView(),
  //     binding: EditArticleBinding(),
  //   ),
  //   GetPage(
  //     name: _Paths.EDIT_VIDEO,
  //     page: () => const EditVideoView(),
  //     binding: EditVideoBinding(),
  //   ),
  // ];

  static final pages = [
    ...AdminPages.pages,
    ...UserPages.pages,
    ...OrgPages.pages,
    ...AuthPages.pages

  ];

}