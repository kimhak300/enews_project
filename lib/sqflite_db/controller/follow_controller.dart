import 'package:get/get.dart';
import 'package:newshub/app/controllers/id_controller.dart';
import 'package:newshub/sqflite_db/service/follow_service.dart';

class FollowController extends GetxController {
  final FollowService _service = FollowService();
  final IdController userId = Get.find();

  /// Track all authors the current user is following
  RxList<int> followingAuthors = <int>[].obs;

  /// Track followers count per author dynamically
  RxMap<int, int> followersCount = <int, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllFollowStatus();
  }

  /// Load all authors that the current user is following
  Future<void> loadAllFollowStatus() async {
    followingAuthors.value =
    await _service.getFollowingAuthors(userId.currentUserId.value);
  }

  /// Check if the current user is following a specific author
  bool isFollowing(int authorId) {
    return followingAuthors.contains(authorId);
  }

  /// Toggle follow/unfollow for a specific author
  Future<void> toggleFollow(int authorId) async {
    if (isFollowing(authorId)) {
      await _service.unfollow(userId.currentUserId.value, authorId);
    } else {
      await _service.follow(userId.currentUserId.value, authorId);
    }

    // Refresh the list after toggle
    await loadAllFollowStatus();

    // Refresh followers count for this author
    await loadFollowersCount(authorId);
  }

  /// Load total followers for a given author
  Future<void> loadFollowersCount(int authorId) async {
    final count = await _service.countFollowers(authorId);
    followersCount[authorId] = count;
  }

  /// Get followers count safely (0 if not loaded yet)
  int countFollowers(int authorId) {
    return followersCount[authorId] ?? 0;
  }
}