import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/app/config/app_config.dart';
import 'package:newshub/modules/user/video/video_controller.dart';
import 'package:newshub/data/models/article_model.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/small_video_player.dart';
import 'package:newshub/core/utils/article_helpers.dart';

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
                      radius: 18.r,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      backgroundImage: (video.author!.avatarUrl != null && video.author!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(video.author!.avatarUrl!)
                          : null,
                      child: (video.author!.avatarUrl == null || video.author!.avatarUrl!.isEmpty)
                          ? Text(
                              video.author!.name.isNotEmpty ? video.author!.name[0].toUpperCase() : 'U',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 10.w),
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
                                    fontSize: 14.sp,
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
                                  final bg = ArticleHelpers.getRoleBadgeColor(video.author!.primaryRole, ctx);
                                  final fg = ArticleHelpers.getRoleBadgeTextColor(video.author!.primaryRole, ctx);
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: bg,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Text(
                                      ArticleHelpers.getRoleLabel(video.author!.primaryRole),
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.bold,
                                        color: fg,
                                      ),
                                    ),
                                  );
                                }),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 12.sp, color: theme.textTheme.bodySmall?.color),
                              SizedBox(width: 4.w),
                              Text(
                                ArticleHelpers.formatDate(video.publishedAt ?? video.createdAt),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: theme.textTheme.bodySmall?.color,
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
                              ? ArticleHelpers.buildImage(coverImage)
                              : Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    size: 80.sp,
                                    color: theme.colorScheme.onPrimary.withOpacity(0.85),
                                  ),
                                ),
                        ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_circle, color: Colors.white, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'video'.tr.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
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
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      height: 1.3,
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
                            color: theme.textTheme.bodyMedium?.color,
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
                        size: 13.sp,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${video.viewCount ?? 0}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
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

  bool _isVideoFile(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.mp4') || 
           lower.endsWith('.mov') || 
           lower.endsWith('.avi') || 
           lower.endsWith('.webm') ||
           lower.endsWith('.mkv') ||
           lower.endsWith('.flv');
  }
}
