import 'package:get/get.dart';
import 'package:newshub/app/controllers/id_controller.dart';
import 'package:newshub/sqflite_db/model/artical_model.dart';
import 'package:newshub/sqflite_db/service/article_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleController extends GetxController {
  var articles = <ArticleModel>[].obs;
  final ArticleService _service = ArticleService();

  // final IdController userId = Get.find(); // inject current user ID

  var currentUserId = 0.obs;

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId.value = prefs.getInt('userId') ?? 0;
  }


  @override
  void onInit() {
    super.onInit();
    // fetch initially
    fetchArticles();

    // refetch articles whenever current user changes
    ever(currentUserId, (_) {
      fetchArticles();
    });
  }

  void fetchArticles() async {
    print('Fetching articles for user: ${currentUserId.value}');
    articles.value = await _service.getAllArticles();
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