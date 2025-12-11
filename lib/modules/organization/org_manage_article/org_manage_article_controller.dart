import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/app/services/storage_service.dart';
import 'package:newshub/data/models/article_model.dart';
import 'package:newshub/api/controller/category_controller.dart' as api_cat;
import 'package:newshub/modules/admin/manage_articles/widgets/create_article_bottomsheet.dart';

class OrgManageArticleController extends GetxController {
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
        final newArticles = data.map((json) => ArticleModel.fromJson(json)).toList();

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

  Future<void> refresh() async {
    await fetchArticles(refresh: true);
  }

  // kept for compatibility with older view code
  void setStatusFilter(String status) => filterByStatus(status);

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
      result = result.where((article) => article.status == selectedStatus.value).toList();
    }

    return result;
  }

  Future<void> deleteArticle(int articleId) async {
    try {
      final response = await _apiService.deleteArticle(articleId);
      if (response.isSuccess) {
        articles.removeWhere((article) => article.id == articleId);
      } else {
        if (response.code == 401) {
          throw Exception('Authentication Required: Please login to delete articles');
        } else {
          throw Exception(response.error ?? 'Failed to delete article');
        }
      }
    } catch (e) {
      print('Error deleting article: $e');
      rethrow;
    }
  }

  void showDeleteConfirmation(ArticleModel article) {
    final storage = Get.find<StorageService>();
    final token = storage.read<String>(AppConstants.TOKEN_KEY);

    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Authentication Required',
        'Please login first to delete articles',
        backgroundColor: Get.theme.colorScheme.secondary,
        colorText: Get.theme.colorScheme.onSecondary,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

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
            onPressed: () async {
              Get.back();
              try {
                await deleteArticle(article.id);
                Get.snackbar(
                  'Success',
                  'Article deleted successfully',
                  backgroundColor: Get.theme.colorScheme.primary,
                  colorText: Get.theme.colorScheme.onPrimary,
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to delete article: ${e.toString()}',
                  backgroundColor: Get.theme.colorScheme.error,
                  colorText: Get.theme.colorScheme.onError,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Get.theme.colorScheme.error),
            child: Text('Delete', style: TextStyle(color: Get.theme.colorScheme.onError)),
          ),
        ],
      ),
    );
  }

  void navigateToCreateArticle() {
    if (!Get.isRegistered<api_cat.CategoryController>()) {
      Get.lazyPut<api_cat.CategoryController>(() => api_cat.CategoryController(), fenix: true);
    }

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (_) => const CreateArticleBottomsheet(),
    ).then((_) => fetchArticles(refresh: true));
  }

  void navigateToEditArticle(int articleId) {
    Get.toNamed('/org-edit-article', arguments: {'articleId': articleId});
  }
}