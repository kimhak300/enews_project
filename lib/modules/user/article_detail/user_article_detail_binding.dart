import 'package:get/get.dart';
import 'user_article_detail_controller.dart';

class UserArticleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserArticleDetailController>(() => UserArticleDetailController());
  }
}
