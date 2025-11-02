import 'package:get/get.dart';
import '../../app/models/article_model.dart';
import '../../app/services/api_service.dart';
import '../../app/routes/app_pages.dart';

class BookmarkController extends GetxController {
  final bookmarkedArticles = <Article>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  void loadBookmarks() {
    final articles = ApiService.getSampleArticles();
    bookmarkedArticles.value = articles.where((a) => a.isBookmarked).take(3).toList();
    
    // Add some dummy bookmarks for demo
    if (bookmarkedArticles.isEmpty && articles.isNotEmpty) {
      articles[0].isBookmarked = true;
      articles[1].isBookmarked = true;
      bookmarkedArticles.value = [articles[0], articles[1]];
    }
  }

  void goToArticleDetail(Article article) {
    Get.toNamed(Routes.ARTICLE_DETAIL, arguments: article);
  }

  void removeBookmark(Article article) {
    article.isBookmarked = false;
    bookmarkedArticles.remove(article);
    Get.snackbar(
      'bookmark'.tr,
      'article_removed_from_bookmarks'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}
