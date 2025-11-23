import 'package:get/get.dart';
import '../service/like_service.dart';

class LikeController extends GetxController {
  final LikeService _service = LikeService();

  RxBool isLiked = false.obs;
  RxInt likeCount = 0.obs;

  Future<void> loadLikeStatus(int userId, int articleId) async {
    isLiked.value = await _service.isLiked(userId, articleId);
    likeCount.value = await _service.countLikes(articleId);
  }

  Future<void> toggleLike(int userId, int articleId) async {
    if (isLiked.value) {
      await _service.removeLike(userId, articleId);
    } else {
      await _service.addLike(userId, articleId);
    }

    await loadLikeStatus(userId, articleId);
  }
}