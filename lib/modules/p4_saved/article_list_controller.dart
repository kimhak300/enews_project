import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../app/models/article_model.dart';
import '../../app/services/api_service.dart';
import '../../app/routes/app_pages.dart';

class ArticleListController extends GetxController {
  final articles = <Article>[].obs;
  final isLoading = false.obs;
  final category = ''.obs;

  @override
  void onInit() {
    super.onInit();
    category.value = Get.arguments as String? ?? 'All';
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    isLoading.value = true;
    try {
      // try json-server first (running on host at port 3000)
      try {
        final baseUrl = 'http://10.0.2.2:3000';
        final uri = Uri.parse('$baseUrl/articles?category=${Uri.encodeComponent(category.value)}');
        final resp = await http.get(uri).timeout(const Duration(seconds: 5));
        if (resp.statusCode == 200) {
          final List<dynamic> list = jsonDecode(resp.body) as List<dynamic>;
          articles.value = list.map((e) => Article.fromJson(e as Map<String, dynamic>)).toList();
          return;
        }
      } catch (e) {
        // ignore and fallback to local sample
        print('json-server fetch failed: $e');
      }

      // fallback to bundled sample data
      final data = await ApiService.getArticlesByCategory(category.value);
      articles.value = data;
    } finally {
      isLoading.value = false;
    }
  }

  void goToArticleDetail(Article article) {
    Get.toNamed(Routes.ARTICLE_DETAIL, arguments: article);
  }
}
