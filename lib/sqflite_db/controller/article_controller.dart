import 'package:get/get.dart';
import 'package:newshub/sqflite_db/model/artical_model.dart';
import 'package:newshub/sqflite_db/service/article_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleController extends GetxController {
  var articles = <ArticleModel>[].obs;
  var searchResults = <ArticleModel>[].obs;

  final ArticleService _service = ArticleService();

  var currentUserId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserId();
    fetchArticles();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId.value = prefs.getInt('userId') ?? 0;
  }

  void fetchArticles() async {
    articles.value = await _service.getAllArticles();
  }

  /// Search excluding current user’s articles
  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      searchResults.clear();
      return;
    }

    searchResults.value =
    await _service.searchArticles(keyword, currentUserId.value);
  }

  void addArticle(ArticleModel article) async {
    await _service.insertArticle(article);
    fetchArticles();
  }

  void updateArticle(ArticleModel article) async {
    await _service.updateArticle(article);
    fetchArticles();
  }

  void deleteArticle(int id) async {
    await _service.deleteArticle(id);
    fetchArticles();
  }
}