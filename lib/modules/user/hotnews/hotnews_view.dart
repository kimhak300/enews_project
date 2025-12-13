import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/app/config/api_constants.dart';
import 'package:newshub/core/utils/video_helper.dart';
import 'package:newshub/modules/user/video/video_detail_view.dart';
import 'package:newshub/modules/user/hotnews/hotnews_controller.dart';
import 'package:newshub/data/models/article_model.dart';

class HotNewsView extends GetView<HotNewsController> {
  const HotNewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('hot_news'.tr),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.hotNews.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.hotNews.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                SizedBox(height: 16.h),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp),
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

        if (controller.hotNews.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_fire_department_outlined, size: 64.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'no_hot_news'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
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
              itemCount: controller.hotNews.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.hotNews.length) {
                  return controller.isLoadingMore.value
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.h),
                            child: const CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink();
                }

                final news = controller.hotNews[index];
                return _buildHotNewsCard(context, news);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHotNewsCard(BuildContext context, ArticleModel news) {
    // Get cover image from media list
    String? coverImage;
    if (news.media != null && news.media!.isNotEmpty) {
      coverImage = news.media!.first;
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
          // If this is a video and has media, open video detail; otherwise open article detail
          try {
            if (news.type == 'video' && news.media != null && news.media!.isNotEmpty) {
              final String raw = news.media!.first;
              final normalized = normalizeVideoSource(raw);
              if (normalized.isNotEmpty) {
                Get.to(() => UserVideoDetailView(videoUrl: normalized, title: news.title));
                return;
              }
            }
          } catch (_) {}

          // Navigate to news detail
          Get.toNamed('/article-detail', arguments: news.toJson());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author profile header
            if (news.author != null)
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      backgroundImage: (news.author!.avatarUrl != null && news.author!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(news.author!.avatarUrl!)
                          : null,
                      child: (news.author!.avatarUrl == null || news.author!.avatarUrl!.isEmpty)
                          ? Text(
                              news.author!.name.isNotEmpty ? news.author!.name[0].toUpperCase() : 'U',
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
                                  news.author!.name,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              // Role badge
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: _getRoleBadgeColor(news.author!.primaryRole),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  _getRoleLabel(news.author!.primaryRole),
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 11.sp, color: Theme.of(context).textTheme.bodySmall?.color),
                              SizedBox(width: 4.w),
                              Text(
                                _formatDate(news.createdAt),
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
            // News content with image and text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Thumbnail
            Stack(
              children: [
                Container(
                  height: 120.h,
                  width: 120.w,
                  color: Theme.of(context).colorScheme.surface,
                  child: coverImage != null
                      ? _buildImage(coverImage)
                      : Icon(
                          Icons.newspaper,
                          size: 36.sp,
                          color: Theme.of(context).disabledColor,
                        ),
                ),
                // Hot badge
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_fire_department, color: Theme.of(context).colorScheme.onSecondary, size: 12.sp),
                        SizedBox(width: 2.w),
                        Text(
                          'hot'.tr,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // News Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (news.subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        news.subtitle!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
      ),
    );
  }

  Widget _buildImage(String imageData) {
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
        return Icon(Icons.broken_image, size: 36.sp, color: Colors.grey[500]);
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
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.broken_image, size: 36.sp, color: Colors.grey[500]),
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
  Color _getRoleBadgeColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.blue;
      case 'organizer':
      case 'organization':
        return Colors.grey;
      default:
        return Colors.red;
    }
  }
}
