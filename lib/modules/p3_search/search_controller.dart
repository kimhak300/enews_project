import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/models/article_model.dart';
import '../../app/services/api_service.dart';
import '../../app/routes/app_pages.dart';

class SearchController extends GetxController {
  final searchController = TextEditingController();
  final searchResults = <Article>[].obs;
  final isSearching = false.obs;
  final recentSearches = <String>['AI Technology', 'Sports News', 'Stock Market'].obs;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      final results = await ApiService.searchArticles(query);
      searchResults.value = results;
      
      if (!recentSearches.contains(query)) {
        recentSearches.insert(0, query);
        if (recentSearches.length > 5) {
          recentSearches.removeLast();
        }
      }
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
