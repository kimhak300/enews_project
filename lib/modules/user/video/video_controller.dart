import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/data/models/article_model.dart';

class VideoController extends GetxController with WidgetsBindingObserver {
  final ApiService _apiService = Get.find<ApiService>();

  // Loading states
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final isRefreshing = false.obs;
  final errorMessage = ''.obs;

  // Pagination
  int currentPage = 1;
  bool hasMore = true;

  // Videos list (articles with type='video')
  final RxList<ArticleModel> videos = <ArticleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchVideos();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refresh();
    }
  }

  Future<void> fetchVideos({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMore = true;
      videos.clear();
      isRefreshing.value = true;
    }

    if (!hasMore && !refresh) return;

    if (currentPage > 1) {
      isLoadingMore.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _apiService.getArticles(page: currentPage, type: 'video');

      if (response.isSuccess) {
        // Handle different response formats
        List data = [];
        if (response.data is List) {
          data = response.data as List;
        } else if (response.data is Map) {
          if (response.data['data'] is List) {
            data = response.data['data'] as List;
          } else if (response.data['articles'] is List) {
            data = response.data['articles'] as List;
          }
        }

        final newVideos =
            data.map((json) => ArticleModel.fromJson(json)).toList();

        if (newVideos.isEmpty) {
          hasMore = false;
        } else {
          videos.addAll(newVideos);
          currentPage++;
        }
      } else {
        errorMessage.value = response.error ?? 'Failed to load videos';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> refresh() async {
    await fetchVideos(refresh: true);
  }

  void loadMore() {
    if (!isLoadingMore.value && hasMore) {
      fetchVideos();
    }
  }
}
