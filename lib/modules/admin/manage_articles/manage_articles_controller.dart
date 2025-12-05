import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/data/models/article_model.dart';

class ManageArticlesController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Loading states
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  // Pagination
  int currentPage = 1;
  bool hasMore = true;

  // Articles list
  final RxList<ArticleModel> articles = <ArticleModel>[].obs;

  // Search & Filter
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedStatus = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchArticles({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMore = true;
      articles.clear();
    }

    if (!hasMore && !refresh) return;

    if (currentPage == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _apiService.getArticles(page: currentPage);

      if (response.isSuccess) {
        final data = response.data['data'] as List? ?? [];
        final newArticles =
            data.map((json) => ArticleModel.fromJson(json)).toList();

        if (newArticles.isEmpty) {
          hasMore = false;
        } else {
          articles.addAll(newArticles);
          currentPage++;
        }
      } else {
        errorMessage.value = response.error ?? 'Failed to load articles';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMore() {
    if (!isLoadingMore.value && hasMore) {
      fetchArticles();
    }
  }

  void refresh() {
    fetchArticles(refresh: true);
  }

  void searchArticles(String query) {
    searchQuery.value = query;
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
  }

  List<ArticleModel> get filteredArticles {
    var result = articles.toList();

    // Filter by search
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((article) {
        return article.title.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by status
    if (selectedStatus.value != 'all') {
      result = result
          .where((article) => article.status == selectedStatus.value)
          .toList();
    }

    return result;
  }

  Future<void> deleteArticle(int articleId) async {
    try {
      final response = await _apiService.deleteArticle(articleId);
      if (response.isSuccess) {
        articles.removeWhere((article) => article.id == articleId);
        Get.snackbar(
          'Success',
          'Article deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to delete article',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showDeleteConfirmation(ArticleModel article) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Article'),
        content: Text('Are you sure you want to delete "${article.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              deleteArticle(article.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}