import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newshub/modules/auth/controllers/login_controller.dart';
import 'package:video_player/video_player.dart';
import '../../app/models/post_model.dart';
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

  // Persistent video posts (stored locally)
  final RxList<Post> videoPosts = <Post>[].obs;

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
    // load persisted video posts
    _loadSavedVideos();
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

  // Persistence for video posts
  static const String _kVideoPostsKey = 'video_posts_v1';

  Future<void> _saveVideos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = videoPosts.map((p) => p.toJson()).toList();
      final encoded = jsonEncode(list);
      await prefs.setString(_kVideoPostsKey, encoded);
    } catch (e) {
      debugPrint('Error saving video posts: $e');
    }
  }

  Future<void> _loadSavedVideos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getString(_kVideoPostsKey);
      if (encoded != null && encoded.isNotEmpty) {
        final List decoded = jsonDecode(encoded) as List;
        final loaded = decoded.map((e) => Post.fromJson(e)).toList();
        videoPosts.assignAll(loaded);
      }
    } catch (e) {
      debugPrint('Error loading video posts: $e');
    }
  }

  Future<void> saveVideos() async {
    await _saveVideos();
  }

  // Refresh method for pull-to-refresh
  final RxBool isRefreshing = false.obs;
  
  Future<void> refreshHomePage() async {
    try {
      isRefreshing.value = true;
      
      // Reload saved video posts
      await _loadSavedVideos();
      
      // Reinitialize videos
      await _initVideos();
      
      // Simulate fetching new data
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get.snackbar(
      //   'refreshed'.tr,
      //   'Content has been updated',
      //   snackPosition: SnackPosition.TOP,
      //   duration: const Duration(seconds: 2),0
      //   backgroundColor: Colors.green.withOpacity(0.7),
      //   colorText: Colors.white,
      // );
    } catch (e) {
      debugPrint('Error refreshing: $e');
      Get.snackbar(
        'error'.tr,
        'Failed to refresh content',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  // Data for the home view tabs
  // final List<Map<String, dynamic>> newsItems = [
  //   {
  //     'image': 'assets/images/news1.png'.tr,
  //     'title': 'ARCTIC FROST EXPOSED'.tr,
  //     'subtitle':
  //         'Biden DOJ chiefs personally signed off on Trump investigation in bombshell memo'.tr,
  //     'readTime': '4 min read',
  //     'isBreaking': true,
  //   },
  //   {
  //     'image': 'assets/images/news2.png'.tr,
  //     'title': 'CAMPUS RADICALS'.tr,
  //     'subtitle': 'University protests escalate as demands grow'.tr,
  //     'readTime': '3 min read'.tr,
  //     'isBreaking': false,
  //   },
  //   {
  //     'image': 'assets/images/news3.png'.tr,
  //     'title': 'GOVERNMENT SHUTDOWN'.tr,
  //     'subtitle': 'Latest developments in the ongoing budget crisis'.tr,
  //     'readTime': '5 min read'.tr,
  //     'isBreaking': true,
  //   },
  // ];

  // final List<Map<String, dynamic>> campusNewsItems = [
  //   {
  //     'image': 'assets/images/campus1.png'.tr,
  //     'title': 'STUDENT PROTESTS GROW'.tr,
  //     'description': 'Students demand policy changes and increased transparency'.tr,
  //     'readTime': '2 min read'.tr,
  //     'isBreaking': false,
  //   },
  //   {
  //     'image': 'assets/images/campus2.png'.tr,
  //     'title': 'UNIVERSITY TO REVIEW CURRICULUM'.tr,
  //     'description': 'Administration opens review following protests'.tr,
  //     'readTime': '3 min read'.tr,
  //     'isBreaking': false,
  //   },
  // ];

  // final List<Map<String, dynamic>> governmentNewsItems = [
  //   {
  //     'image': 'assets/images/gov1.png'.tr,
  //     'title': 'BUDGET TALKS INTENSIFY'.tr,
  //     'description': 'Lawmakers push for compromise ahead of deadline'.tr,
  //     'readTime': '6 min read'.tr,
  //     'isBreaking': true,
  //   },
  // ];

  final List<String> topTabs = [
    'home',
    'following',
    'popular',
    'news',
    // 'sports',
    // 'entertainment',
    // 'technology',
  ];


  void updateCarouselIndex(int index) {
    carouselCurrentIndex.value = index;
  }

  void goToSearch() {
    Get.toNamed(Routes.SEARCH);
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

}