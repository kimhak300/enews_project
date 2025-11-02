import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../app/models/article_model.dart';

class ArticleDetailController extends GetxController {
  late Article article;
  final isBookmarked = false.obs;

  @override
  void onInit() {
    super.onInit();
    article = Get.arguments as Article;
    isBookmarked.value = article.isBookmarked;
  }

  void toggleBookmark() {
    isBookmarked.value = !isBookmarked.value;
    article.isBookmarked = isBookmarked.value;
    Get.snackbar(
      'Bookmark',
      isBookmarked.value ? 'Article saved' : 'Article removed',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void shareArticle() {
    Share.share(
      '${article.title}\n\nRead more on eNews',
      subject: article.title,
    );
  }
}
