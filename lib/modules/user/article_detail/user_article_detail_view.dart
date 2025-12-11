import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/core/widgets/video_player_widget.dart';
import 'package:newshub/app/config/api_constants.dart';
import 'user_article_detail_controller.dart';

class UserArticleDetailView extends GetView<UserArticleDetailController> {
  const UserArticleDetailView({super.key});

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(type == 'video' ? 'Video' : type == 'news_feed' ? 'Hot News' : 'Article'),
        elevation: 0,
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
                        final catName = cat is String ? cat : cat['name'] ?? 'Category';
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            catName.toString().toUpperCase(),
                            style: TextStyle(
                              color: Colors.blue,
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
                    ),
                  ),
                  
                  // Subtitle
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
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
                        color: Colors.grey[700],
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
                        color: Colors.black87,
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

  Widget _buildActionButtons() {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Like Button
          _buildActionButton(
            icon: controller.isLiked.value ? Icons.favorite : Icons.favorite_border,
            label: controller.likeCount.value.toString(),
            color: controller.isLiked.value ? Colors.red : Colors.grey,
            onTap: () => controller.toggleLike(),
          ),
          
          // Comment Button
          _buildActionButton(
            icon: Icons.comment_outlined,
            label: controller.commentCount.value.toString(),
            color: Colors.grey,
            onTap: () => _showCommentDialog(),
          ),
          
          // Share Button
          _buildActionButton(
            icon: Icons.share_outlined,
            label: controller.shareCount.value.toString(),
            color: Colors.grey,
            onTap: () => controller.shareArticle(),
          ),
          
          // Bookmark Button
          _buildActionButton(
            icon: controller.isBookmarked.value ? Icons.bookmark : Icons.bookmark_border,
            label: controller.isBookmarked.value ? 'Saved' : 'Save',
            color: controller.isBookmarked.value ? Colors.amber : Colors.grey,
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
                Icon(Icons.comment_outlined, size: 48.sp, color: Colors.grey[400]),
                SizedBox(height: 8.h),
                Text(
                  'No comments yet',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                TextButton.icon(
                  onPressed: () => _showCommentDialog(),
                  icon: Icon(Icons.add_comment),
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
              TextButton.icon(
                onPressed: () => _showCommentDialog(),
                icon: Icon(Icons.add_comment, size: 18.sp),
                label: Text('Add'),
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
      if (!avatarUrl.startsWith('http://') && !avatarUrl.startsWith('https://')) {
        avatarUrl = '${ApiConstants.mediaBaseUrl}${avatarUrl.startsWith('/') ? avatarUrl : '/$avatarUrl'}';
      }
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: Colors.blue[100],
          child: avatarUrl != null
              ? ClipOval(
                  child: Image.network(
                    avatarUrl,
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.person, size: 20.sp, color: Colors.blue),
                  ),
                )
              : Icon(Icons.person, size: 20.sp, color: Colors.blue),
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
                  color: Colors.grey[600],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
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
          child: Icon(Icons.error_outline, size: 48.sp, color: Colors.grey[500]),
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
    final images = media.where((m) => 
      m.isNotEmpty && m != 'null' && !_isVideo(m)
    ).toList();
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
        imageUrl = '${ApiConstants.mediaBaseUrl}${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}';
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
      color: Colors.grey[300],
      child: Center(
        child: Icon(Icons.broken_image, size: 48.sp, color: Colors.grey[500]),
      ),
    );
  }

  bool _isVideo(String media) {
    final lower = media.toLowerCase();
    return lower.endsWith('.mp4') || lower.endsWith('.mov') || 
           lower.endsWith('.avi') || lower.endsWith('.webm') ||
           lower.contains('/video/');
  }
}
