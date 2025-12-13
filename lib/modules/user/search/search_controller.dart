import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/data/models/article_model.dart';

class SearchController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final TextEditingController searchTextController = TextEditingController();

  final isLoading = false.obs;
  final isSearching = false.obs;
  final searchQuery = ''.obs;
  final articles = <ArticleModel>[].obs;
  final filteredArticles = <ArticleModel>[].obs;
  final errorMessage = ''.obs;

  // Filters
  final selectedCategory = Rxn<String>();
  final selectedSort = 'latest'.obs; // latest, popular, oldest

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.getArticles(perPage: 50);

      if (response.isSuccess) {
        List data = [];
        if (response.data is List) {
          data = response.data as List;
        } else if (response.data is Map) {
          if (response.data['data'] is List) {
            data = response.data['data'] as List;
          }
        }

        articles.value =
            data.map((json) => ArticleModel.fromJson(json)).toList();
        applyFilters();
      } else {
        errorMessage.value = response.error ?? 'Failed to load articles';
      }
    } catch (e) {
      errorMessage.value = 'Error: \${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    searchQuery.value = query.toLowerCase();
    applyFilters();
  }

  void applyFilters() {
    var filtered = articles.toList();

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((article) {
        return article.title.toLowerCase().contains(searchQuery.value) ||
            (article.excerpt?.toLowerCase().contains(searchQuery.value) ??
                false) ||
            (article.content?.toLowerCase().contains(searchQuery.value) ??
                false);
      }).toList();
    }

    // Category filter
    if (selectedCategory.value != null) {
      filtered = filtered.where((article) {
        return article.categories?.any(
              (cat) => cat.name == selectedCategory.value,
            ) ??
            false;
      }).toList();
    }

    // Sort
    switch (selectedSort.value) {
      case 'popular':
        filtered.sort((a, b) => (b.viewCount ?? 0).compareTo(a.viewCount ?? 0));
        break;
      case 'oldest':
        filtered.sort((a, b) => (a.publishedAt ?? a.createdAt ?? DateTime.now())
            .compareTo(b.publishedAt ?? b.createdAt ?? DateTime.now()));
        break;
      case 'latest':
      default:
        filtered.sort((a, b) => (b.publishedAt ?? b.createdAt ?? DateTime.now())
            .compareTo(a.publishedAt ?? a.createdAt ?? DateTime.now()));
    }

    filteredArticles.value = filtered;
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    applyFilters();
  }

  void setCategory(String? category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void setSort(String sort) {
    selectedSort.value = sort;
    applyFilters();
  }

  Future<void> refresh() async {
    await fetchArticles();
  }

  List<String> get allCategories {
    final categories = <String>{};
    for (var article in articles) {
      if (article.categories != null) {
        for (var cat in article.categories!) {
          categories.add(cat.name);
        }
      }
    }
    return categories.toList()..sort();
  }
}
