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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('hot_news'.tr),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: theme.appBarTheme.foregroundColor ?? theme.colorScheme.onPrimary,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.hotNews.isEmpty) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary)));
        }

        if (controller.errorMessage.isNotEmpty && controller.hotNews.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.sp, color: theme.colorScheme.error),
                SizedBox(height: 16.h),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
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
                Icon(Icons.local_fire_department_outlined, size: 64.sp, color: theme.disabledColor),
                SizedBox(height: 16.h),
                Text(
                  'no_hot_news'.tr,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16.sp, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9)),
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
                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary)),
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
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      backgroundImage: (news.author!.avatarUrl != null && news.author!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(news.author!.avatarUrl!)
                          : null,
                      child: (news.author!.avatarUrl == null || news.author!.avatarUrl!.isEmpty)
                          ? Text(
                              news.author!.name.isNotEmpty ? news.author!.name[0].toUpperCase() : 'U',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
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
                                      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  // Role badge
                                  Builder(builder: (ctx) {
                                    final bg = _getRoleBadgeColor(news.author!.primaryRole, ctx);
                                    final fg = _getRoleBadgeTextColor(news.author!.primaryRole, ctx);
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: bg,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        _getRoleLabel(news.author!.primaryRole),
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
                              Icon(Icons.access_time, size: 11.sp, color: theme.textTheme.bodySmall?.color),
                              SizedBox(width: 4.w),
                              Text(
                                _formatDate(news.createdAt),
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp),
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
                  color: theme.colorScheme.surface,
                  child: coverImage != null
                      ? _buildImage(context, coverImage)
                      : Icon(
                          Icons.newspaper,
                          size: 36.sp,
                          color: theme.disabledColor,
                        ),
                ),
                // Hot badge
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_fire_department, color: theme.colorScheme.onSecondary, size: 12.sp),
                        SizedBox(width: 2.w),
                        Text(
                          'hot'.tr,
                          style: TextStyle(
                            color: theme.colorScheme.onSecondary,
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
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 15.sp, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (news.subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        news.subtitle!,
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.sp, color: theme.textTheme.bodyMedium?.color),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 6.h),
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
                          '${news.viewCount ?? 0}',
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
            ),
          ],
        ),
      ],
    ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String imageData) {
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
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 36.sp, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
