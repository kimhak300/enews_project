import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/app/config/app_config.dart';
import 'package:newshub/modules/user/video/video_controller.dart';
import 'package:newshub/data/models/article_model.dart';
import 'package:newshub/app/config/api_constants.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/small_video_player.dart';

class VideoView extends GetView<VideoController> {
  const VideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('videos_label'.tr),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.videos.isEmpty) {
          return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
        }

        if (controller.errorMessage.isNotEmpty && controller.videos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.sp, color: Theme.of(context).colorScheme.error),
                SizedBox(height: 16.h),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        if (controller.videos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_library_outlined, size: 64.sp, color: Theme.of(context).colorScheme.onSurfaceVariant),
                SizedBox(height: 16.h),
                Text(
                  'no_videos'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  !controller.isLoadingMore.value) {
                controller.loadMore();
              }
              return false;
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: controller.videos.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.videos.length) {
                  return controller.isLoadingMore.value
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.h),
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink();
                }

                final video = controller.videos[index];
                return _buildVideoCard(context, video);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVideoCard(BuildContext context, ArticleModel video) {
    // Find video URL from media list
    String? videoUrl;
    String? coverImage;
    
    if (video.media != null && video.media!.isNotEmpty) {
      // Try to find video file
      try {
        videoUrl = video.media!.firstWhere(
          (media) => _isVideoFile(media),
          orElse: () => '',
        );
        if (videoUrl.isEmpty) videoUrl = null;
        
        // Try to find image for fallback
        coverImage = video.media!.firstWhere(
          (media) => !_isVideoFile(media),
          orElse: () => '',
        );
        if (coverImage.isEmpty) coverImage = null;
      } catch (e) {
        videoUrl = null;
        coverImage = null;
      }
    }
    
    // Construct full video URL if found
    if (videoUrl != null && !videoUrl.startsWith('http://') && !videoUrl.startsWith('https://')) {
      videoUrl = AppConfig.getImageUrl(videoUrl);
    }

    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navigate to video detail
          Get.toNamed('/article-detail', arguments: video.toJson());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author profile header
            if (video.author != null)
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      backgroundImage: (video.author!.avatarUrl != null && video.author!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(video.author!.avatarUrl!)
                          : null,
                      child: (video.author!.avatarUrl == null || video.author!.avatarUrl!.isEmpty)
                          ? Text(
                              video.author!.name.isNotEmpty ? video.author!.name[0].toUpperCase() : 'U',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    // Author name and role
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  video.author!.name,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 6.w),
                                // Role badge
                                Builder(builder: (ctx) {
                                  final bg = _getRoleBadgeColor(video.author!.primaryRole, ctx);
                                  final fg = _getRoleBadgeTextColor(video.author!.primaryRole, ctx);
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: bg,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      _getRoleLabel(video.author!.primaryRole),
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.bold,
                                        color: fg,
                                      ),
                                    ),
                                  );
                                }),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 11.sp, color: Theme.of(context).textTheme.bodySmall?.color),
                              SizedBox(width: 4.w),
                              Text(
                                _formatDate(video.createdAt),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // Video Thumbnail with SmallVideoPlayer
            Stack(
              children: [
                SizedBox(
                  height: 180.h,
                  width: double.infinity,
                  child: videoUrl != null
                      ? SmallVideoPlayer(
                          url: videoUrl,
                          width: double.infinity,
                          height: 180.h,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                            ),
                          ),
                          child: coverImage != null && !_isVideoFile(coverImage)
                              ? _buildImage(coverImage)
                              : Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    size: 80.sp,
                                    color: theme.colorScheme.onPrimary.withOpacity(0.85),
                                  ),
                                ),
                        ),
                ),
                // Play button overlay
                Positioned.fill(
                  child: Center(
                      child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: theme.colorScheme.onSurface,
                        size: 36.sp,
                      ),
                    ),
                  ),
                ),
                // Video badge
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.videocam, color: Theme.of(context).colorScheme.onError, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'video'.tr.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Video Info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (video.subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      video.subtitle!,
                      style: TextStyle(
                            fontSize: 13.sp,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 8.h),
                  // View count
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 12.sp,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${video.viewCount ?? 0}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageData) {
    // Check if it's a video file first - don't try to load as image
    if (_isVideoFile(imageData)) {
      return Builder(builder: (ctx) {
        final theme = Theme.of(ctx);
        return Center(
          child: Icon(
            Icons.play_circle_outline,
            size: 80.sp,
            color: theme.colorScheme.onPrimary.withOpacity(0.8),
          ),
        );
      });
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
        print('❌ Base64 decode error: $e');
        return Builder(builder: (ctx) => Icon(Icons.broken_image, size: 48.sp, color: Theme.of(ctx).colorScheme.onSurfaceVariant));
      }
    } else {
      // URL image - convert relative paths to full URLs
      String imageUrl = imageData;
      if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
        // Relative path - prepend base URL
        imageUrl = '${ApiConstants.mediaBaseUrl}${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}';
      }
      
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Image load error: $error');
          print('❌ Attempted URL: $imageUrl');
          return Builder(builder: (ctx) => Center(child: Icon(Icons.broken_image, size: 48.sp, color: Theme.of(ctx).colorScheme.onSurfaceVariant)));
        },
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Just now';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _isVideoFile(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.mp4') || 
           lower.endsWith('.mov') || 
           lower.endsWith('.avi') || 
           lower.endsWith('.webm') ||
           lower.endsWith('.mkv') ||
           lower.endsWith('.flv');
  }

  // Get role display label
  String _getRoleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'official_account'.tr.toUpperCase();
      case 'organizer':
      case 'organization':
        return 'news_organizer'.tr.toUpperCase();
      default:
        return 'user'.tr.toUpperCase();
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
