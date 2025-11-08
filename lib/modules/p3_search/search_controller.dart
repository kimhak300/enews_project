import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import '../../app/models/article_model.dart';
import '../../app/services/api_service.dart';
import '../../app/routes/app_pages.dart';

class SearchController extends GetxController {
  // Only use multi-video logic for trending videos

  // Trending videos
  final List<String> trendingVideoUrls = [
    'https://v.ftcdn.net/04/16/40/07/700_F_416400718_QNEWtuTZxcZsJM5ZJRZT5KQIGeCHH1vX_ST.mp4',
    'https://v.ftcdn.net/04/87/46/71/700_F_487467184_HunAD0le8m3apdReGPWQ2e0LvVZaeHeb_ST.mp4',
    'https://v.ftcdn.net/17/51/39/37/700_F_1751393724_1ULD2fo6f6bZCSvi6I31N24JXZIKR9JP_ST.mp4',
    'https://v.ftcdn.net/17/40/21/49/240_F_1740214971_5s4AQn4g8GvD7viDNfFkctsii3atPhUi_ST.mp4',
    'https://v.ftcdn.net/17/64/37/54/240_F_1764375479_Ej16KjEH40IOYOyA5Qb3DZofIDVtYXgL_ST.mp4',
    
  ];


  List<VideoPlayerController> videoControllers = [];
  List<RxBool> isInitializedList = [];
  List<RxBool> isPlayingList = [];
  List<Rx<Duration>> positionList = [];
  List<Rx<Duration>> durationList = [];

  // Search
  final TextEditingController searchController = TextEditingController();
  final RxList<Article> searchResults = <Article>[].obs;
  final RxBool isSearching = false.obs;
  final RxList<String> recentSearches = <String>['AI Technology', 'Sports News', 'Stock Market'].obs;

 @override
  void onInit() {
    super.onInit();
    trendingVideoUrls;
    _initVideos();
  }
    @override
  void onClose() {
    for (final c in videoControllers) {
      try {
        c.dispose();
      } catch (_) {}
    }
    searchController.dispose();
    super.onClose();
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

  void seekTo(int index, Duration newPosition) {
    if (index < 0 || index >= videoControllers.length) return;
    videoControllers[index].seekTo(newPosition);
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    isSearching.value = true;
    try {
      final results = await ApiService.searchArticles(query);
      searchResults.assignAll(results);
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

  void goToArticleDetail(Article article) {
    Get.toNamed(Routes.ARTICLE_DETAIL, arguments: article);
  }
}
      