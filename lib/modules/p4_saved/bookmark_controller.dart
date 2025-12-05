// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../app/models/post_model.dart';
//
// class BookmarkController extends GetxController {
//   final savedPosts = <Post>[].obs;
//
//   static const String _kSavedPostsKey = 'saved_posts_v1';
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadSavedPosts();
//   }
//
//   Future<void> _loadSavedPosts() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final encoded = prefs.getString(_kSavedPostsKey);
//       if (encoded != null && encoded.isNotEmpty) {
//         final List decoded = jsonDecode(encoded) as List;
//         final loaded = decoded.map((e) => Post.fromJson(e)).toList();
//         savedPosts.assignAll(loaded);
//       }
//     } catch (e) {
//       print('Error loading saved posts: $e');
//     }
//   }
//
//   Future<void> _savePosts() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final list = savedPosts.map((p) => p.toJson()).toList();
//       final encoded = jsonEncode(list);
//       await prefs.setString(_kSavedPostsKey, encoded);
//     } catch (e) {
//       print('Error saving posts: $e');
//     }
//   }
//
//   void savePost(Post post) {
//     // Check if already saved
//     final index = savedPosts.indexWhere((p) => p.id == post.id);
//     if (index == -1) {
//       savedPosts.add(post);
//       _savePosts();
//       Get.snackbar(
//         'saved'.tr,
//         'Post saved successfully',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 2),
//       );
//     } else {
//       Get.snackbar(
//         'saved'.tr,
//         'Post already saved',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 1),
//       );
//     }
//   }
//
//   void removeSavedPost(Post post) {
//     savedPosts.removeWhere((p) => p.id == post.id);
//     _savePosts();
//     Get.snackbar(
//       'removed'.tr,
//       'Post removed from saved',
//       snackPosition: SnackPosition.TOP,
//       duration: const Duration(seconds: 1),
//     );
//   }
//
//   bool isPostSaved(String postId) {
//     return savedPosts.any((p) => p.id == postId);
//   }
// }
