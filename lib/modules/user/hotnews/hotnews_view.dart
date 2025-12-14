import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/core/utils/video_helper.dart';
import 'package:newshub/modules/user/video/video_detail_view.dart';
import 'package:newshub/modules/user/hotnews/hotnews_controller.dart';
import 'package:newshub/modules/user/home/widgets/article_card_widget.dart';

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
                return ArticleCardWidget(
                  article: news,
                  badgeText: 'hot'.tr,
                  badgeColor: Theme.of(context).colorScheme.secondary,
                  badgeIcon: Icons.local_fire_department,
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
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
