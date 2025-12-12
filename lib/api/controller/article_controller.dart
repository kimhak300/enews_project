// lib/modules/articles/controllers/article_controller.dart
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:newshub/api/model/article_model.dart';
import 'package:newshub/api/service/article_service.dart';

class ArticleController extends GetxController {
  final ArticleService _service = ArticleService();

  var articles = <ArticleModel>[].obs;
  // Keep an unfiltered copy of fetched articles for client-side search/filter
  List<ArticleModel> allArticles = [];
  final TextEditingController searchController = TextEditingController();
  var isLoading = false.obs;

  /// Client-side search by title/subtitle/excerpt
  void searchArticles(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      articles.value = List<ArticleModel>.from(allArticles);
      return;
    }

    final filtered = allArticles.where((a) {
      final title = a.title.toLowerCase();
      final subtitle = a.subtitle.toLowerCase();
      final excerpt = a.excerpt.toLowerCase();
      return title.contains(q) || subtitle.contains(q) || excerpt.contains(q);
    }).toList();

    articles.value = filtered;
  }

  /// Client-side filter by status (e.g., 'published','draft','archived')
  void filterByStatus(String status) {
    if (status == 'all') {
      articles.value = List<ArticleModel>.from(allArticles);
      return;
    }

    final filtered = allArticles.where((a) {
      final s = a.status.toLowerCase();
      return s == status.toLowerCase();
    }).toList();

    articles.value = filtered;
  }

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  Future<void> fetchArticles({String? category}) async {
    try {
      isLoading.value = true;
      final result = await _service.getArticles(category: category);
      articles.value = result;
      // store unfiltered copy
      allArticles = List<ArticleModel>.from(result);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createArticle(Map<String, dynamic> body) async {
    try {
      await _service.createArticle(body);
      // Don't show snackbar here - let the caller handle UI feedback
      fetchArticles();
    } catch (e) {
      print('Create article error: $e');
      rethrow;
    }
  }

  Future<void> updateArticle(int id, Map<String, dynamic> body) async {
    try {
      await _service.updateArticle(id, body);
      // Don't show snackbar here - let the caller handle UI feedback
      fetchArticles();
    } catch (e) {
      print('Update article error: $e');
      rethrow;
    }
  }

  Future<void> deleteArticle(int id) async {
    try {
      await _service.deleteArticle(id);
      // Don't show snackbar here - let the caller handle UI feedback
      fetchArticles();
    } catch (e) {
      print('Delete article error: $e');
      rethrow;
    }
  }

  Future<void> fetchArticlesByCategory(String category) async {
    try {
      isLoading.value = true;
      final result = await _service.getArticlesByCategory(category);
      articles.value = result;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}