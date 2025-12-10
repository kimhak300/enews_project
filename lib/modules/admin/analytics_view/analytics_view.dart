import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'analytics_controller.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: Colors.blueAccent,
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
                // Engagement Metrics Section
                Text(
                  'Engagement Metrics',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12.h),
                
                // Engagement Cards Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.5,
                  children: [
                    _buildMetricCard(
                      icon: Icons.favorite,
                      color: Colors.red,
                      title: 'Total Likes',
                      value: controller.totalLikes.value.toString(),
                    ),
                    _buildMetricCard(
                      icon: Icons.comment,
                      color: Colors.blue,
                      title: 'Total Comments',
                      value: controller.totalComments.value.toString(),
                    ),
                    _buildMetricCard(
                      icon: Icons.share,
                      color: Colors.green,
                      title: 'Total Shares',
                      value: controller.totalShares.value.toString(),
                    ),
                    _buildMetricCard(
                      icon: Icons.bookmark,
                      color: Colors.orange,
                      title: 'Total Bookmarks',
                      value: controller.totalBookmarks.value.toString(),
                    ),
                  ],
                ),
                
                SizedBox(height: 24.h),
                
                // Article Stats Section
                Text(
                  'Article Statistics',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
                      icon: Icons.article,
                      color: Colors.purple,
                      title: 'Total Articles',
                      value: controller.totalArticles.value.toString(),
                    ),
                    _buildMetricCard(
                      icon: Icons.publish,
                      color: Colors.teal,
                      title: 'Published',
                      value: controller.publishedArticles.value.toString(),
                    ),
                    _buildMetricCard(
                      icon: Icons.drafts,
                      color: Colors.grey,
                      title: 'Drafts',
                      value: controller.draftArticles.value.toString(),
                    ),
                    _buildMetricCard(
                      icon: Icons.people,
                      color: Colors.indigo,
                      title: 'Total Users',
                      value: controller.totalUsers.value.toString(),
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

  Widget _buildMetricCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
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
            colors: [color.withOpacity(0.1), Colors.white],
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
            Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[600],
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