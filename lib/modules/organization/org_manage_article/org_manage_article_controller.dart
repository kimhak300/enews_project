import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/api/controller/category_controller.dart' as api_cat;
import 'package:newshub/modules/admin/manage_articles/widgets/create_article_bottomsheet.dart';

class OrgManageArticleController extends GetxController {
  final ApiService _apiService = ApiService.to;

  final isLoading = false.obs;
  final articles = <Map<String, dynamic>>[].obs;
  final filteredArticles = <Map<String, dynamic>>[].obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;
  final selectedStatus = 'all'.obs; // all, published, draft

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.getArticles();

      if (response.isSuccess) {
        final data = (response.data['data'] as List?) ?? [];
        articles.value = data.cast<Map<String, dynamic>>();
        applyFilters();
      } else {
        errorMessage.value = response.error ?? 'Failed to load articles';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    var filtered = articles.toList();

    // Filter by status
    if (selectedStatus.value != 'all') {
      filtered = filtered.where((a) => a['status'] == selectedStatus.value).toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((a) {
        final title = (a['title'] ?? '').toString().toLowerCase();
        final query = searchQuery.value.toLowerCase();
        return title.contains(query);
      }).toList();
    }

    filteredArticles.value = filtered;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
    applyFilters();
  }

  Future<void> deleteArticle(int articleId) async {
    try {
      final response = await _apiService.deleteArticle(articleId);

      if (response.isSuccess) {
        // Success - let the caller handle UI feedback
        fetchArticles();
      } else {
        throw Exception(response.error ?? 'Failed to delete article');
      }
    } catch (e) {
      print('Error deleting article: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    await fetchArticles();
  }

  void navigateToCreateArticle() {
    // Ensure API CategoryController is registered before showing bottomsheet
    if (!Get.isRegistered<api_cat.CategoryController>()) {
      Get.lazyPut<api_cat.CategoryController>(() => api_cat.CategoryController(), fenix: true);
    }
    
    // Show create article bottomsheet
    Get.bottomSheet(
      const CreateArticleBottomsheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void navigateToEditArticle(int articleId) {
    // Navigate to edit article page
    Get.toNamed('/org-edit-article', arguments: {'articleId': articleId});
  }
}