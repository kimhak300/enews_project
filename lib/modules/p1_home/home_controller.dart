import 'package:get/get.dart';
import 'package:newshub/modules/auth/controllers/login_controller.dart';

import '../../app/models/article_model.dart';
import '../../app/routes/app_pages.dart';

class HomeController extends GetxController {
  final _loginController = Get.find<LoginController>();

  final currentTopTab = 0.obs;
  final currentNavIndex = 0.obs;
  final carouselCurrentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void handleNavigation(int index) {
    currentNavIndex.value = index;
  }

  // Data for the home view tabs
  final List<Map<String, dynamic>> newsItems = [
    {
      'image': 'assets/images/news1.png',
      'title': 'ARCTIC FROST EXPOSED',
      'subtitle':
          'Biden DOJ chiefs personally signed off on Trump investigation in bombshell memo',
      'readTime': '4 min read',
      'isBreaking': true,
    },
    {
      'image': 'assets/images/news2.png',
      'title': 'CAMPUS RADICALS',
      'subtitle': 'University protests escalate as demands grow',
      'readTime': '3 min read',
      'isBreaking': false,
    },
    {
      'image': 'assets/images/news3.png',
      'title': 'GOVERNMENT SHUTDOWN',
      'subtitle': 'Latest developments in the ongoing budget crisis',
      'readTime': '5 min read',
      'isBreaking': true,
    },
  ];

  final List<Map<String, dynamic>> campusNewsItems = [
    {
      'image': 'assets/images/campus1.png',
      'title': 'STUDENT PROTESTS GROW',
      'description': 'Students demand policy changes and increased transparency',
      'readTime': '2 min read',
      'isBreaking': false,
    },
    {
      'image': 'assets/images/campus2.png',
      'title': 'UNIVERSITY TO REVIEW CURRICULUM',
      'description': 'Administration opens review following protests',
      'readTime': '3 min read',
      'isBreaking': false,
    },
  ];

  final List<Map<String, dynamic>> governmentNewsItems = [
    {
      'image': 'assets/images/gov1.png',
      'title': 'BUDGET TALKS INTENSIFY',
      'description': 'Lawmakers push for compromise ahead of deadline',
      'readTime': '6 min read',
      'isBreaking': true,
    },
  ];

  final List<String> topTabs = [
    'Home',
    'CAMPUS RADICALS',
    'GOVERNMENT SHUTDOWN'
  ];


  void updateCarouselIndex(int index) {
    carouselCurrentIndex.value = index;
  }
    void goToArticleDetail(Article article) {
    Get.toNamed(Routes.ARTICLE_DETAIL, arguments: article);
  }

  void goToSearch() {
    Get.toNamed(Routes.SEARCH);
  }



  void goToCategory(String category) {
    Get.toNamed(Routes.ARTICLE_LIST, arguments: category);
  }

  void setTopTab(int index) {
    currentTopTab.value = index;
  }

    Future<void> _goNext() async {
    final hasToken = await _loginController.hasToken();

    if (hasToken) {
      // Get.offAllNamed(AppRoutes.bottomNav);
      Get.offAllNamed('AppRoutes.bottomNav');
    } else {
      Get.offAllNamed('AppRoutes.login');
    }
  }

  // Future<void> refreshNews() async {
  //   await fetchNews();
  // }
}