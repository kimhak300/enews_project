import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newshub/app/models/post_model.dart';
import 'package:newshub/modules/p1_home/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  HomeController? _homeController;
  bool _ownsVideoControllers = true;
  // Only use multi-video logic for trending videos

  // Trending videos
  final currentTopTab = 0.obs;
  final currentNavIndex = 0.obs;
  final carouselCurrentIndex = 0.obs;
  final List<String> trendingVideoUrls = [
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
  // Search
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearching = false.obs;
  final RxList<String> recentSearches =
      <String>['AI Technology', 'Sports News', 'Stock Market'].obs;

  @override
  void onInit() {
    super.onInit();
    try {
      _homeController = Get.find<HomeController>();
    } catch (_) {
      _homeController = null;
    }

    if (_homeController != null) {
      _ownsVideoControllers = false;
      // Reuse the initialized controllers from Home to ensure identical playback
      videoControllers = _homeController!.videoControllers;
      isInitializedList = _homeController!.isInitializedList;
      isPlayingList = _homeController!.isPlayingList;
      positionList = _homeController!.positionList;
      durationList = _homeController!.durationList;
      trendingVideoUrls
        ..clear()
        ..addAll(_homeController!.homeVideoUrls);
    } else {
      _initVideos();
    }

    _loadSavedVideos();
  }

  @override
  void onClose() {
    if (_ownsVideoControllers) {
      for (final c in videoControllers) {
        try {
          c.dispose();
        } catch (_) {}
      }
    }
    searchController.dispose();
    super.onClose();
  }

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

  // Persistence for video posts
  static const String _kVideoPostsKey = 'video_posts_v1';
  Future<void> saveVideos() async {
    await _saveVideos();
  }

  Future<void> _initVideos() async {
    // Initialize all videos in parallel so they all show up at once
    final initFutures = <Future<void>>[];

    for (final url in trendingVideoUrls) {
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
      initFutures.add(controller.initialize().then((_) {
        controller.setLooping(true);
        controller.setVolume(1.0);
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
        debugPrint('Search video initialized successfully: $url');
      }).catchError((e, s) {
        debugPrint('Trending video init failed: $e\n$s');
        // Still mark as initialized to show error state instead of infinite loading
        isInit.value = true;
      }));
    }

    // Wait for all videos to initialize
    await Future.wait(initFutures);
    debugPrint('All ${trendingVideoUrls.length} search videos initialized');
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

  void seekTo(int index, Duration newPosition) {
    if (index < 0 || index >= videoControllers.length) return;
    videoControllers[index].seekTo(newPosition);
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      return;
    }
    isSearching.value = true;
    try {
      // Search functionality can be implemented with posts
      if (!recentSearches.contains(query)) {
        recentSearches.insert(0, query);
        if (recentSearches.length > 5) {
          recentSearches.removeLast();
        }
      }
    } catch (e, s) {
      debugPrint('Search failed: $e\n$s');
    } finally {
      isSearching.value = false;
    }
  }

  void removeRecentSearch(String query) {
    recentSearches.remove(query);
  }
}
