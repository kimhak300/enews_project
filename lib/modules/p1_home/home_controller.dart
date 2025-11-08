import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/auth/controllers/login_controller.dart';
import 'package:video_player/video_player.dart';
import '../../app/models/article_model.dart';
import '../../app/routes/app_pages.dart';

class HomeController extends GetxController {
  LoginController? _loginController;
  final TextEditingController homeController = TextEditingController();
  final currentTopTab = 0.obs;
  final currentNavIndex = 0.obs;
  final carouselCurrentIndex = 0.obs;
    final List<String> homeVideoUrls = [
    'https://v.ftcdn.net/04/56/03/45/240_F_456034564_6ZArfnOEnU26iDfQchh2pcTEBTmneK65_ST.mp4',
    'https://v.ftcdn.net/15/27/13/84/240_F_1527138400_4rjdTWqXmkEiAhT15iKbV86wQNQHxMU9_ST.mp4',
    'https://v.ftcdn.net/06/76/59/08/240_F_676590824_X5y86CIBTpOfqhOb0Xp2N1A6xquPZ0bX_ST.mp4',
    'https://v.ftcdn.net/02/82/49/07/240_F_282490702_ZCYI9D54mVuSKHpuv23avtk0fcYKckM1_ST.mp4',
    'https://v.ftcdn.net/17/64/37/54/240_F_1764375479_Ej16KjEH40IOYOyA5Qb3DZofIDVtYXgL_ST.mp4',
  ];

  List<VideoPlayerController> videoControllers = [];
  List<RxBool> isInitializedList = [];
  List<RxBool> isPlayingList = [];
  List<Rx<Duration>> positionList = [];
  List<Rx<Duration>> durationList = [];

  @override
  void onInit() {
    super.onInit();
    // Try to find LoginController if it exists
    try {
      _loginController = Get.find<LoginController>();
    } catch (e) {
      // LoginController not initialized yet, that's okay
    }
    homeVideoUrls;
    _initVideos();
  }
    @override
  void onClose() {
    for (final c in videoControllers) {
      try {
        c.dispose();
      } catch (_) {}
    }
    homeController.dispose();
    super.onClose();
  }

    Future<void> _initVideos() async {
    // Initialize all videos in parallel so they all show up at once
    final initFutures = <Future<void>>[];
    
    for (final url in homeVideoUrls) {
      final controller = VideoPlayerController.network(url);
      final isInit = false.obs;
      final isPlay = false.obs;
      final pos = Duration.zero.obs;
      final dur = Duration.zero.obs;
      videoControllers.add(controller);
      isInitializedList.add(isInit);
      isPlayingList.add(isPlay);
      positionList.add(pos);
      durationList.add(dur);
      
      // Initialize each video in parallel
      initFutures.add(
        controller.initialize().then((_) {
          controller.setLooping(true);
          isInit.value = true;
          pos.value = controller.value.position;
          dur.value = controller.value.duration;
          isPlay.value = controller.value.isPlaying;
          controller.addListener(() {
            if (!isInit.value) return;
            pos.value = controller.value.position;
            dur.value = controller.value.duration;
            isPlay.value = controller.value.isPlaying;
          });
        }).catchError((e, s) {
          debugPrint('Trending video init failed: $e\n$s');
        })
      );
    }
    
    // Wait for all videos to initialize
    await Future.wait(initFutures);
  }

  void playPause(int index) {
    if (index < 0 || index >= videoControllers.length) return;
    for (int i = 0; i < videoControllers.length; i++) {
      if (i != index && videoControllers[i].value.isPlaying) {
        videoControllers[i].pause();
        isPlayingList[i].value = false;
      }
    }
    final controller = videoControllers[index];
    if (controller.value.isPlaying) {
      controller.pause();
      isPlayingList[index].value = false;
    } else {
      controller.play();
      isPlayingList[index].value = true;
    } 

  }

  void handleNavigation(int index) {
    currentNavIndex.value = index;
  }

  // Data for the home view tabs
  final List<Map<String, dynamic>> newsItems = [
    {
      'image': 'assets/images/news1.png'.tr,
      'title': 'ARCTIC FROST EXPOSED'.tr,
      'subtitle':
          'Biden DOJ chiefs personally signed off on Trump investigation in bombshell memo'.tr,
      'readTime': '4 min read',
      'isBreaking': true,
    },
    {
      'image': 'assets/images/news2.png'.tr,
      'title': 'CAMPUS RADICALS'.tr,
      'subtitle': 'University protests escalate as demands grow'.tr,
      'readTime': '3 min read'.tr,
      'isBreaking': false,
    },
    {
      'image': 'assets/images/news3.png'.tr,
      'title': 'GOVERNMENT SHUTDOWN'.tr,
      'subtitle': 'Latest developments in the ongoing budget crisis'.tr,
      'readTime': '5 min read'.tr,
      'isBreaking': true,
    },
  ];

  final List<Map<String, dynamic>> campusNewsItems = [
    {
      'image': 'assets/images/campus1.png'.tr,
      'title': 'STUDENT PROTESTS GROW'.tr,
      'description': 'Students demand policy changes and increased transparency'.tr,
      'readTime': '2 min read'.tr,
      'isBreaking': false,
    },
    {
      'image': 'assets/images/campus2.png'.tr,
      'title': 'UNIVERSITY TO REVIEW CURRICULUM'.tr,
      'description': 'Administration opens review following protests'.tr,
      'readTime': '3 min read'.tr,
      'isBreaking': false,
    },
  ];

  final List<Map<String, dynamic>> governmentNewsItems = [
    {
      'image': 'assets/images/gov1.png'.tr,
      'title': 'BUDGET TALKS INTENSIFY'.tr,
      'description': 'Lawmakers push for compromise ahead of deadline'.tr,
      'readTime': '6 min read'.tr,
      'isBreaking': true,
    },
  ];

  final List<String> topTabs = [
    'home',
    'following',
    'popular',
    'news',
    'sports',
    'entertainment',
    'technology',
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
    final hasToken = await _loginController?.hasToken() ?? false;

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