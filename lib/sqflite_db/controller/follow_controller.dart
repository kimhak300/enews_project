import 'package:get/get.dart';
import 'package:newshub/app/controllers/id_controller.dart';
import 'package:newshub/sqflite_db/service/follow_service.dart';

class FollowController extends GetxController {
  final FollowService _service = FollowService();
  final IdController userId = Get.find();

  RxList<int> followingAuthors = <int>[].obs;

  // Make followersCount reactive per author
  RxMap<int, RxInt> followersCount = <int, RxInt>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllFollowStatus();
  }

  Future<void> loadAllFollowStatus() async {
    followingAuthors.value =
    await _service.getFollowingAuthors(userId.currentUserId.value);
  }

  bool isFollowing(int authorId) {
    return followingAuthors.contains(authorId);
  }

  Future<void> toggleFollow(int authorId) async {
    if (isFollowing(authorId)) {
      await _service.unfollow(userId.currentUserId.value, authorId);
    } else {
      await _service.follow(userId.currentUserId.value, authorId);
    }

    // Refresh follow list
    await loadAllFollowStatus();

    // Refresh followers count reactively
    await loadFollowersCount(authorId);
  }

  Future<void> loadFollowersCount(int authorId) async {
    final count = await _service.countFollowers(authorId);
    if (followersCount[authorId] != null) {
      followersCount[authorId]!.value = count;
    } else {
      followersCount[authorId] = count.obs;
    }
  }

  // Return RxInt for Obx
  RxInt getFollowersCountRx(int authorId) {
    if (followersCount[authorId] == null) {
      followersCount[authorId] = 0.obs;
    }
    return followersCount[authorId]!;
  }
}