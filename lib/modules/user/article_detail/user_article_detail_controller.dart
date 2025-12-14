import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../api/service/article_interaction_service.dart';
import '../../../api/service/follow_service.dart';
import '../../../data/models/article_model.dart';
import 'package:newshub/app/utils/image_utils.dart';

class CommentModel {
  final int id;
  final String content;
  final String authorName;
  final String? authorAvatar;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.content,
    required this.authorName,
    this.authorAvatar,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      content: json['content_text'] ?? '',
      authorName: json['user']?['display_name'] ?? 'Anonymous',
      authorAvatar: json['user']?['avatar'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class UserArticleDetailController extends GetxController {
  final ArticleInteractionService _interactionService =
      ArticleInteractionService();
  final FollowService _followService = FollowService();

  late ArticleModel article;

  // Observable states
  final isLiked = false.obs;
  final isBookmarked = false.obs;
  final isFollowing = false.obs;
  final likeCount = 0.obs;
  final commentCount = 0.obs;
  final shareCount = 0.obs;
  final isLoading = false.obs;

  // Controllers
  final ScrollController scrollController = ScrollController();
  final FocusNode commentFocusNode = FocusNode();

  // Comments
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Get article from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      article = ArticleModel.fromJson(args);

      // Initialize counts from article data
      likeCount.value = article.likeCount ?? 0;
      commentCount.value = article.commentCount ?? 0;
      shareCount.value = 0;

      // Track view when article is opened
      _trackArticleView();

      // Load all data - these will update the UI as they complete
      _initializeArticleData();
    }
  }

  /// Track article view
  Future<void> _trackArticleView() async {
    try {
      await _interactionService.trackArticleView(article.id);
    } catch (e) {
      // Silent fail - view tracking shouldn't interrupt user experience
      print('Failed to track view: $e');
    }
  }

  /// Initialize article data from backend
  Future<void> _initializeArticleData() async {
    // Run these in parallel for better performance
    await Future.wait([
      reloadArticleStats(),
      checkLikeStatus(),
      checkBookmarkStatus(),
      checkFollowStatus(),
      loadComments(),
    ]);
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  /// Check if article is bookmarked
  Future<void> checkBookmarkStatus() async {
    try {
      isBookmarked.value =
          await _interactionService.checkIfBookmarked(article.id);
    } catch (e) {
      print('Error checking bookmark status: $e');
    }
  }

  /// Check if article is liked by current user
  Future<void> checkLikeStatus() async {
    try {
      // Call backend to check if user has liked this article
      final result = await _interactionService.checkIfLiked(article.id);
      isLiked.value = result;
    } catch (e) {
      print('Error checking like status: $e');
      isLiked.value = false;
    }
  }

  /// Check if current user is following the article author
  Future<void> checkFollowStatus() async {
    try {
      final authorId = article.authorId;
      if (authorId != null) {
        isFollowing.value = await _followService.checkIfFollowing(authorId);
      }
    } catch (e) {
      print('Error checking follow status: $e');
      isFollowing.value = false;
    }
  }

  /// Toggle follow/unfollow article author
  /// ✅ This updates the UserFollow table → Admin analytics will count it by role
  Future<void> toggleFollow() async {
    try {
      final authorId = article.authorId;
      if (authorId == null) {
        Get.snackbar(
          'Error',
          'Cannot follow: Author not found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (isFollowing.value) {
        // Unfollow
        final success = await _followService.unfollowUser(authorId);
        if (success) {
          isFollowing.value = false;
          Get.snackbar(
            'Success',
            'Unfollowed ${article.author?.displayName ?? "author"}',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to unfollow',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        // Follow
        final success = await _followService.followUser(authorId);
        if (success) {
          isFollowing.value = true;
          Get.snackbar(
            'Success',
            'Following ${article.author?.displayName ?? "author"}! 🎉',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to follow',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print('Error toggling follow: $e');
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Toggle like/unlike
  /// ✅ This updates the Reaction table → Admin analytics will count it
  Future<void> toggleLike() async {
    try {
      if (isLiked.value) {
        // Unlike
        final result = await _interactionService.unlikeArticle(article.id);
        if (result['success']) {
          isLiked.value = false;
          if (likeCount.value > 0) likeCount.value--;
          // Reload actual count from backend
          await reloadArticleStats();
          Get.snackbar(
            'Success',
            'Article unliked!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            'Error',
            result['error'] ?? 'Failed to unlike',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        // Like
        final result = await _interactionService.likeArticle(article.id);
        if (result['success']) {
          isLiked.value = true;
          likeCount.value++;
          // Reload actual count from backend
          await reloadArticleStats();
          Get.snackbar(
            'Success',
            'Article liked! ❤️',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } else {
          // Check if user needs to login
          if (result['error']?.contains('401') == true) {
            Get.snackbar(
              'Login Required',
              'Please login first to like articles',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              'Error',
              result['error'] ?? 'Failed to like',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      }
    } catch (e) {
      print('Error toggling like: $e');
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Toggle bookmark/unbookmark
  /// ✅ This updates the UserBookmark table → Admin analytics will count it
  Future<void> toggleBookmark() async {
    try {
      if (isBookmarked.value) {
        // Remove bookmark
        final result = await _interactionService.removeBookmark(article.id);
        if (result['success']) {
          isBookmarked.value = false;
          await reloadArticleStats();
          Get.snackbar(
            'Success',
            'Bookmark removed!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            'Error',
            result['error'] ?? 'Failed to remove bookmark',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        // Add bookmark
        final result = await _interactionService.addBookmark(article.id);
        if (result['success']) {
          isBookmarked.value = true;
          await reloadArticleStats();
          Get.snackbar(
            'Success',
            'Article bookmarked! 🔖',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } else {
          if (result['error']?.contains('401') == true) {
            Get.snackbar(
              'Login Required',
              'Please login first to bookmark articles',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              'Error',
              result['error'] ?? 'Failed to bookmark',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Share article
  /// ✅ Tracked in backend Share table → Admin analytics will count it
  Future<void> shareArticle() async {
    try {
      // Copy article content/link to clipboard
      final shareText = '''
${article.title}

${article.content ?? ''}

Read more at: NewsHub
      ''';

      await Clipboard.setData(ClipboardData(text: shareText));

      // Track share in backend (adds to shares table → counted in admin analytics)
      await _interactionService.trackShare(article.id, platform: 'copy_link');

      // Reload actual count from backend
      await reloadArticleStats();

      Get.snackbar(
        'Shared',
        'Article content copied to clipboard! 🔗',
        backgroundColor: Colors.grey[600],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error sharing: $e');
      Get.snackbar(
        'Error',
        'Failed to share article',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Reload article stats from backend after interaction
  Future<void> reloadArticleStats() async {
    try {
      // Get updated article details from backend
      final response = await _interactionService.getArticleStats(article.id);
      if (response['success']) {
        final data = response['data'];
        likeCount.value = data['like_count'] ?? likeCount.value;
        commentCount.value = data['comment_count'] ?? commentCount.value;
        shareCount.value = data['share_count'] ?? shareCount.value;
      }
    } catch (e) {
      print('Error reloading stats: $e');
    }
  }

  /// Load comments
  Future<void> loadComments() async {
    try {
      final result = await _interactionService.getComments(article.id);
      if (result['success']) {
        final data = result['data'];
        final commentsList = (data['data'] as List?) ?? [];
        comments.value =
            commentsList.map((json) => CommentModel.fromJson(json)).toList();
        commentCount.value = comments.length;
      }
    } catch (e) {
      print('Error loading comments: $e');
    }
  }

  /// Post a comment
  /// ✅ This updates the Comment table → Admin analytics will count it
  Future<void> postComment() async {
    final content = commentController.text.trim();
    if (content.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a comment',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final result = await _interactionService.postComment(article.id, content);

      if (result['success']) {
        // Clear input
        commentController.clear();

        // Reload comments
        await loadComments();

        Get.snackbar(
          'Success',
          'Comment posted! 💬',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        if (result['error']?.contains('401') == true) {
          Get.snackbar(
            'Login Required',
            'Please login first to comment',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            result['error'] ?? 'Failed to post comment',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print('Error posting comment: $e');
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Show comment bottom sheet
  void showCommentSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Row(
              children: [
                const Icon(Icons.comment, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Obx(() => Text(
                      '${commentCount.value}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 16),

            // Comments list
            Obx(() => comments.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'No comments yet. Be the first to comment!',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                resolveImageProvider(comment.authorAvatar),
                            child: comment.authorAvatar == null
                                ? Text(comment.authorName.isNotEmpty
                                    ? comment.authorName[0].toUpperCase()
                                    : '?')
                                : null,
                          ),
                          title: Text(
                            comment.authorName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(comment.content),
                        );
                      },
                    ),
                  )),

            const SizedBox(height: 16),

            // Comment input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => IconButton(
                      onPressed: isLoading.value ? null : postComment,
                      icon: isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      color: Colors.blue,
                    )),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
