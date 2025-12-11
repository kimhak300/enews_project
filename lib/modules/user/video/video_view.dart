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
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.videos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
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
                Icon(Icons.video_library_outlined, size: 64.sp, color: Colors.grey),
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
                              colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                            ),
                          ),
                          child: coverImage != null && !_isVideoFile(coverImage)
                              ? _buildImage(coverImage)
                              : Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    size: 80.sp,
                                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.85),
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
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
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
                  Row(
                    children: [
                      // Author info with role
                      if (video.author != null) ...[
                        CircleAvatar(
                          radius: 10.sp,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          child: Text(
                            video.author!.name.isNotEmpty ? video.author!.name[0].toUpperCase() : 'A',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            video.author!.name,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Role badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: _getRoleColor(video.author?.primaryRole ?? 'user').withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            (video.author?.primaryRole ?? 'user').toUpperCase(),
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: _getRoleColor(video.author?.primaryRole ?? 'user'),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Icon(Icons.access_time, size: 14.sp, color: Theme.of(context).textTheme.bodySmall?.color),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDate(video.createdAt),
                        style: TextStyle(
                          fontSize: 12.sp,
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
    );
  }

  Widget _buildImage(String imageData) {
    // Check if it's a video file first - don't try to load as image
    if (_isVideoFile(imageData)) {
      return Center(
        child: Icon(
          Icons.play_circle_outline,
          size: 80.sp,
          color: Colors.white.withOpacity(0.8),
        ),
      );
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
        return Icon(Icons.broken_image, size: 48.sp, color: Colors.grey[500]);
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
          return Center(
            child: Icon(Icons.broken_image, size: 48.sp, color: Colors.grey[500]),
          );
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

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'organizer':
      case 'organization':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
