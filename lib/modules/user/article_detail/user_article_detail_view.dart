import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/core/widgets/video_player_widget.dart';
import 'package:newshub/app/config/api_constants.dart';
import 'user_article_detail_controller.dart';

class UserArticleDetailView extends GetView<UserArticleDetailController> {
  const UserArticleDetailView({super.key});

  ThemeData get theme => Theme.of(Get.context!);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> article = Get.arguments ?? {};

    final String title = article['title'] ?? 'Article';
    final String? subtitle = article['subtitle'];
    final String? content = article['content'] ?? article['content_html'];
    final String? excerpt = article['excerpt'];
    final String type = article['type'] ?? 'article';
    final List<String> media = List<String>.from(article['media'] ?? []);
    final List categories = article['categories'] ?? [];

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(type == 'video'
            ? 'Video'
            : type == 'news_feed'
                ? 'Hot News'
                : 'Article'),
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: theme.appBarTheme.foregroundColor ?? theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media Section
            if (media.isNotEmpty) ...[
              if (type == 'video')
                _buildVideoSection(media)
              else
                _buildImageSection(media),
              SizedBox(height: 16.h),
            ],

            // Profile Header Section
            _buildProfileHeader(article),
            SizedBox(height: 16.h),

            // Content Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  if (categories.isNotEmpty) ...[
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: categories.map((cat) {
                        final catName =
                            cat is String ? cat : cat['name'] ?? 'Category';
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            catName.toString().toUpperCase(),
                            style: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  // Title
                  Text(
                    title,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          color: theme.colorScheme.onSurface,
                        ),
                  ),

                  // Subtitle
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.85),
                        height: 1.4,
                      ),
                    ),
                  ],

                  SizedBox(height: 16.h),

                  // Excerpt
                  if (excerpt != null && excerpt.isNotEmpty) ...[
                    Text(
                      excerpt,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  // Content
                  if (content != null && content.isNotEmpty) ...[
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1.7,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],

                  SizedBox(height: 24.h),

                  // Action Buttons Row
                  _buildActionButtons(),

                  SizedBox(height: 24.h),

                  // Comments Section
                  _buildCommentsSection(),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> article) {
    final theme = Theme.of(Get.context!);
    final author = article['author'];

    // Extract author name with multiple fallbacks
    String authorName = 'Unknown Author';
    if (author != null) {
      authorName = author['display_name']?.toString() ??
          author['full_name']?.toString() ??
          author['name']?.toString() ??
          'Unknown Author';
    }

    // Extract avatar URL with multiple fallbacks
    final authorAvatar = author?['avatar_url'] ?? author?['avatar'];

    // Extract publish date
    final publishedAt = article['published_at'] ?? article['created_at'];

    // Extract role - check roles array first, then role field
    String authorRole = 'user';
    if (author != null) {
      // Check if roles is a list with role objects
      if (author['roles'] is List && (author['roles'] as List).isNotEmpty) {
        final rolesList = author['roles'] as List;
        final firstRole = rolesList.first;
        if (firstRole is Map) {
          authorRole =
              firstRole['role_name']?.toString().toLowerCase() ?? 'user';
        } else if (firstRole is String) {
          authorRole = firstRole.toLowerCase();
        }
      } else if (author['role'] != null &&
          author['role'].toString().isNotEmpty) {
        authorRole = author['role'].toString().toLowerCase();
      }
    }

    // Fix avatar URL - build full URL if needed
    String? avatarUrl;
    if (authorAvatar != null && authorAvatar.toString().isNotEmpty) {
      avatarUrl = authorAvatar.toString();
      if (!avatarUrl.startsWith('http://') &&
          !avatarUrl.startsWith('https://') &&
          !avatarUrl.startsWith('data:')) {
        avatarUrl =
            '${ApiConstants.mediaBaseUrl}${avatarUrl.startsWith('/') ? avatarUrl : '/$avatarUrl'}';
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Avatar with fallback to initials
          CircleAvatar(
            radius: 20.r,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
            backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                ? NetworkImage(avatarUrl)
                : null,
            child: (avatarUrl == null || avatarUrl.isEmpty)
                ? Text(
                    authorName.isNotEmpty ? authorName[0].toUpperCase() : 'U',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 12.w),

          // Author name and role badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        authorName,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyLarge?.color ??
                            theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    // Role badge - always show for all roles
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: _getRoleBadgeColor(authorRole, Get.context!),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                          _getRoleLabel(authorRole),
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                            color: _getRoleBadgeTextColor(authorRole, Get.context!),
                          ),
                        ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.access_time,
                      size: 12.sp,
                      color: theme.textTheme.bodySmall?.color ??
                        theme.colorScheme.onSurface.withOpacity(0.7)),
                    SizedBox(width: 4.w),
                    Text(
                      _formatPublishDate(publishedAt),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.textTheme.bodySmall?.color ??
                            Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Follow button
          Obx(() => InkWell(
                onTap: () => controller.toggleFollow(),
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: controller.isFollowing.value
                        ? theme.colorScheme.surfaceVariant
                        : theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    controller.isFollowing.value ? Icons.check : Icons.add,
                    color: theme.colorScheme.onPrimary,
                    size: 18.sp,
                  ),
                ),
              )),

          SizedBox(width: 8.w),

          // More options button
          InkWell(
            onTap: () => _showMoreOptions(),
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.more_horiz,
                color: theme.iconTheme.color,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatViewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatPublishDate(dynamic date) {
    if (date == null) return 'Recently';

    try {
      DateTime publishedDate;
      if (date is String) {
        // Try to parse the string, if it fails return Recently
        final parsed = DateTime.tryParse(date);
        if (parsed == null) return 'Recently';
        publishedDate = parsed;
      } else if (date is DateTime) {
        publishedDate = date;
      } else {
        return 'Recently';
      }

      final now = DateTime.now();
      final difference = now.difference(publishedDate);

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays == 1) {
        return '1d ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '${weeks}w ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '${months}mo ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '${years}y ago';
      }
    } catch (e) {
      print('Error parsing date: $e');
      return 'Recently';
    }
  }

  void _showMoreOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            _buildOptionItem(
              icon: Icons.report_outlined,
              title: 'Report',
              onTap: () {
                Get.back();
                Get.snackbar('Report', 'Report feature coming soon');
              },
            ),
            _buildOptionItem(
              icon: Icons.block_outlined,
              title: 'Block this user',
              onTap: () {
                Get.back();
                Get.snackbar('Block', 'Block feature coming soon');
              },
            ),
            _buildOptionItem(
              icon: Icons.info_outline,
              title: 'About this article',
              onTap: () {
                Get.back();
                Get.snackbar('Info', 'Article info coming soon');
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, size: 24.sp, color: theme.colorScheme.onSurface),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.dividerColor, width: 1),
              bottom: BorderSide(color: theme.dividerColor, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Like Button
                _buildActionButton(
                icon: controller.isLiked.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                label: controller.likeCount.value.toString(),
                color: controller.isLiked.value ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                onTap: () => controller.toggleLike(),
              ),

              // Comment Button
                _buildActionButton(
                icon: Icons.comment_outlined,
                label: controller.commentCount.value.toString(),
                color: theme.colorScheme.onSurfaceVariant,
                onTap: () => _showCommentDialog(),
              ),

              // Share Button
                _buildActionButton(
                icon: Icons.share_outlined,
                label: controller.shareCount.value.toString(),
                color: theme.colorScheme.onSurfaceVariant,
                onTap: () => controller.shareArticle(),
              ),

              // Bookmark Button
                _buildActionButton(
                icon: controller.isBookmarked.value
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                label: controller.isBookmarked.value ? 'Saved' : 'Save',
                color: controller.isBookmarked.value ? theme.colorScheme.secondary : theme.colorScheme.onSurfaceVariant,
                onTap: () => controller.toggleBookmark(),
              ),
            ],
          ),
        ));
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Obx(() {
      if (controller.comments.isEmpty) {
                return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                Icon(Icons.comment_outlined,
                    size: 48.sp, color: theme.colorScheme.onSurfaceVariant),
                SizedBox(height: 8.h),
                Text(
                  'No comments yet',
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7), fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                TextButton.icon(
                  onPressed: () => _showCommentDialog(),
                  icon: Icon(Icons.add_comment, color: theme.iconTheme.color),
                  label: Text('Be the first to comment'),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comments (${controller.commentCount.value})',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
          SizedBox(height: 12.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.comments.length,
            separatorBuilder: (_, __) => Divider(height: 24.h),
            itemBuilder: (context, index) {
              final comment = controller.comments[index];
              return _buildCommentItem(comment);
            },
          ),
        ],
      );
    });
  }

  Widget _buildCommentItem(CommentModel comment) {
    // Fix avatar URL
    String? avatarUrl;
    if (comment.authorAvatar != null && comment.authorAvatar!.isNotEmpty) {
      avatarUrl = comment.authorAvatar!;
      if (!avatarUrl.startsWith('http://') &&
          !avatarUrl.startsWith('https://')) {
        avatarUrl =
            '${ApiConstants.mediaBaseUrl}${avatarUrl.startsWith('/') ? avatarUrl : '/$avatarUrl'}';
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: avatarUrl != null
              ? ClipOval(
                  child: Image.network(
                    avatarUrl,
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.person, size: 20.sp, color: theme.colorScheme.primary),
                  ),
                )
                : Icon(Icons.person, size: 20.sp, color: theme.colorScheme.primary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.authorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                comment.content,
                style: TextStyle(fontSize: 14.sp, height: 1.4),
              ),
              SizedBox(height: 4.h),
              Text(
                _formatTime(comment.createdAt),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCommentDialog() {
    Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Comment',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: controller.commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.all(12.w),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.commentController.clear();
                      Get.back();
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.commentController.text.trim().isNotEmpty) {
                        controller.postComment();
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text('Post'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildVideoSection(List<String> media) {
    // Find video file and validate it's not null/empty
    final videoUrl = media.firstWhere(
      (m) => m.isNotEmpty && m != 'null' && _isVideo(m),
      orElse: () => '',
    );

    // If no valid video URL found, show placeholder
    if (videoUrl.isEmpty || videoUrl == 'null') {
      return Container(
        width: double.infinity,
        height: 250.h,
        color: Colors.grey[300],
        child: Center(
          child:
              Icon(Icons.error_outline, size: 48.sp, color: Colors.grey[500]),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 250.h,
      color: Colors.black,
      child: VideoPlayerWidget(
        videoUrl: videoUrl,
        height: 250.h,
        width: double.infinity,
        showControls: true,
      ),
    );
  }

  Widget _buildImageSection(List<String> media) {
    // Filter out videos, null/empty values, keep only valid images
    final images = media
        .where((m) => m.isNotEmpty && m != 'null' && !_isVideo(m))
        .toList();
    if (images.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: 250.h,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return _buildImage(images[index]);
        },
      ),
    );
  }

  Widget _buildImage(String imageData) {
    // Validate image data is not null or empty
    if (imageData.isEmpty || imageData == 'null') {
      return _errorPlaceholder();
    }

    if (imageData.startsWith('data:image')) {
      // Base64 image
      try {
        final base64String = imageData.split(',').last;
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } catch (e) {
        return _errorPlaceholder();
      }
    } else {
      // URL image - convert relative paths to full URLs
      String imageUrl = imageData;
      if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
        imageUrl =
            '${ApiConstants.mediaBaseUrl}${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}';
      }

      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
      );
    }
  }

  Widget _errorPlaceholder() {
    return Container(
      color: theme.colorScheme.surfaceVariant,
      child: Center(
        child: Icon(Icons.broken_image, size: 48.sp, color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }

  bool _isVideo(String media) {
    final lower = media.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.webm') ||
        lower.contains('/video/');
  }

  // Get role display label
  String _getRoleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'OFFICIAL ACCOUNT';
      case 'organizer':
      case 'organization':
        return 'NEWS ORGANIZER';
      default:
        return 'USER';
    }
  }

  // Get role badge color
  Color _getRoleBadgeColor(String role, BuildContext context) {
    final theme = Theme.of(context);
    switch (role.toLowerCase()) {
      case 'admin':
        return theme.colorScheme.primary;
      case 'organizer':
      case 'organization':
        return theme.colorScheme.surfaceVariant;
      default:
        return theme.colorScheme.error;
    }
  }

  Color _getRoleBadgeTextColor(String role, BuildContext context) {
    final theme = Theme.of(context);
    switch (role.toLowerCase()) {
      case 'admin':
        return theme.colorScheme.onPrimary;
      case 'organizer':
      case 'organization':
        return theme.colorScheme.onSurfaceVariant;
      default:
        return theme.colorScheme.onError;
    }
  }
}
