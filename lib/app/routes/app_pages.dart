import 'package:get/get.dart';
import '../../modules/p1_home/home_binding.dart';
import '../../modules/p1_home/home_screen/home_view.dart';
import '../../modules/p3_search/search_binding.dart';
import '../../modules/p3_search/search_screen/search_view.dart';
import '../../modules/p4_saved/article_detail_binding.dart';
import '../../modules/p4_saved/article_list_binding.dart';
import '../../modules/p4_saved/bookmark_binding.dart';
import '../../modules/p4_saved/saved_screen/article_detail_view.dart';
import '../../modules/p4_saved/saved_screen/article_list_view.dart';
import '../../modules/p4_saved/saved_screen/bookmark_view.dart';
import '../../modules/p5_profile/about_binding.dart';
import '../../modules/p5_profile/profile_binding.dart';
import '../../modules/p5_profile/profile_screen/about_view.dart';
import '../../modules/p5_profile/profile_screen/profile_view.dart';
import '../../modules/p5_profile/profile_screen/settings_view.dart';
import '../../modules/p5_profile/settings_binding.dart';
import '../../modules/splash/splash_view.dart';
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/auth/bindings/login_binding.dart';
import '../../modules/auth/bindings/register_binding.dart';
import '../../modules/auth/bindings/forgot_password_binding.dart';
import '../../modules/p2_dashboard/dashboard_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/register_view.dart';
import '../../modules/auth/views/forgot_password_view.dart';
import '../../modules/p2_dashboard/dashboard_screen/dashboard_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = <GetPage>[
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      preventDuplicates: true,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLE_LIST,
      page: () => const ArticleListView(),
      binding: ArticleListBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLE_DETAIL,
      page: () => const ArticleDetailView(),
      binding: ArticleDetailBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.BOOKMARK,
      page: () => const BookmarkView(),
      binding: BookmarkBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
  ];
}
