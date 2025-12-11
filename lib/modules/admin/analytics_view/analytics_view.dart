import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'analytics_controller.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text('reports_analytics'.tr),
        backgroundColor: theme.colorScheme.primary,
        elevation: 2,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return RefreshIndicator(
          onRefresh: controller.fetchStats,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'article_statistics'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.5,
                  children: [
                    _buildMetricCard(
                      context,
                      icon: Icons.favorite,
                      color: Colors.red,
                      title: 'total_likes'.tr,
                      value: controller.totalLikes.value.toString(),
                    ),
                    _buildMetricCard(
                      context,
                      icon: Icons.comment,
                      color: Colors.blue,
                      title: 'total_comments'.tr,
                      value: controller.totalComments.value.toString(),
                    ),
                    _buildMetricCard(
                      context,
                      icon: Icons.share,
                      color: Colors.green,
                      title: 'total_shares'.tr,
                      value: controller.totalShares.value.toString(),
                    ),
                    _buildMetricCard(
                      context,
                      icon: Icons.bookmark,
                      color: Colors.orange,
                      title: 'total_bookmarks'.tr,
                      value: controller.totalBookmarks.value.toString(),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.5,
                  children: [
                    _buildMetricCard(
                      context,
                      icon: Icons.publish,
                      color: Colors.teal,
                      title: 'published'.tr,
                      value: controller.publishedArticles.value.toString(),
                    ),
                    _buildMetricCard(
                      context,
                      icon: Icons.drafts,
                      color: Colors.grey,
                      title: 'drafts'.tr,
                      value: controller.draftArticles.value.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMetricCard(BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.12), theme.colorScheme.surfaceVariant],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 28.sp,
            ),
            const Spacer(),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}