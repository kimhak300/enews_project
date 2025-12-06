// lib/modules/articles/controllers/article_controller.dart
import 'package:get/get.dart';
import 'package:newshub/api/model/article_model.dart';
import 'package:newshub/api/service/article_service.dart';

class ArticleController extends GetxController {
  final ArticleService _service = ArticleService();

  var articles = <ArticleModel>[].obs;
  var isLoading = false.obs;

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
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createArticle(Map<String, dynamic> body) async {
    try {
      await _service.createArticle(body);
      // Get.snackbar('Success', 'Article created');
      fetchArticles();
    } catch (e) {
      print(e);
      // Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateArticle(int id, Map<String, dynamic> body) async {
    try {
      await _service.updateArticle(id, body);
      Get.snackbar('Success', 'Article updated');
      fetchArticles();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteArticle(int id) async {
    try {
      await _service.deleteArticle(id);
      Get.snackbar('Success', 'Article deleted');
      fetchArticles();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> fetchArticlesByCategory(String category) async {
    try {
      isLoading.value = true;
      final result = await _service.getArticlesByCategory(category);
      articles.value = result;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}