import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/data/models/article_model.dart';

class BookmarkController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Loading state
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  // Bookmarks list
  final RxList<ArticleModel> bookmarks = <ArticleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookmarks();
  }

  Future<void> fetchBookmarks() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiService.getBookmarks();

      if (response.isSuccess) {
        final data = response.data['data'] as List? ?? [];
        bookmarks.assignAll(
          data.map((json) => ArticleModel.fromJson(json['article'] ?? json)).toList(),
        );
      } else {
        errorMessage.value = response.error ?? 'Failed to load bookmarks';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    fetchBookmarks();
  }

  Future<void> removeBookmark(int articleId) async {
    try {
      final response = await _apiService.removeBookmark(articleId);
      if (response.isSuccess) {
        bookmarks.removeWhere((article) => article.id == articleId);
        Get.snackbar(
          'Success',
          'Bookmark removed',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to remove bookmark',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showRemoveConfirmation(ArticleModel article) {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Bookmark'),
        content: Text('Remove "${article.title}" from bookmarks?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              removeBookmark(article.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}