import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/config/app_config.dart';
import 'package:newshub/app/widget/app_drawer_widget.dart';
import 'package:newshub/modules/auth/services/auth_service.dart';
import 'package:newshub/data/models/user_model.dart';
import 'package:newshub/data/models/stats_model.dart';
import 'package:newshub/modules/organization/org_home/org_home_controller.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/small_video_player.dart';

class OrgHomeView extends GetView<OrgHomeController> {
  const OrgHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('organization_dashboard'.tr),
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.colorScheme.primary,
        foregroundColor:
            theme.appBarTheme.foregroundColor ?? theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.iconTheme.color),
            onPressed: controller.refresh,
          ),
        ],
      ),
      drawer: FutureBuilder<UserModel?>(
        future: AuthService().getSavedUser(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          final role = user?.primaryRole ?? 'user';
          final name = user?.name ?? 'Guest';
          final email = user?.email ?? '';
          final avatar = user?.avatarUrl;

          return AppDrawerWidget(
            userRole: role,
            userName: name,
            userEmail: email,
            userAvatar: avatar,
          );
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child:
                  CircularProgressIndicator(color: theme.colorScheme.primary));
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.4)),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchDashboardStats,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Text(
                  'organization_dashboard'.tr,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.92),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'manage_articles_team'.tr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Cards Grid
                _buildStatsGrid(context),
                const SizedBox(height: 24),

                // Quick Actions
                _buildSectionTitle(context, 'quick_actions'.tr),
                const SizedBox(height: 12),
                _buildQuickActions(context),
                const SizedBox(height: 24),

                // Recent Articles Section
                _buildSectionTitle(context, 'recent_articles'.tr),
                const SizedBox(height: 12),
                _buildRecentArticlesList(context),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          title: 'total_articles'.tr,
          value: controller.totalArticles.value.toString(),
          icon: Icons.article,
          color: theme.colorScheme.primary,
          context: context,
        ),
        _buildStatCard(
          title: 'published'.tr,
          value: controller.publishedArticles.value.toString(),
          icon: Icons.check_circle,
          color: theme.colorScheme.secondary,
          context: context,
        ),
        _buildStatCard(
          title: 'Organizer Followers'.tr,
          value: controller.organizerFollowers.value.toString(),
          icon: Icons.people_outline,
          color: Colors.grey,
          context: context,
        ),
        _buildStatCard(
          title: 'total_views'.tr,
          value: controller.totalViews.value.toString(),
          icon: Icons.visibility,
          color: theme.colorScheme.secondaryContainer,
          context: context,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: theme.colorScheme.onSurface.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 24, fontWeight: FontWeight.bold, color: color)),
              Text(title,
                  style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.7))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) + 2,
          color: theme.colorScheme.onSurface.withOpacity(0.92),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            title: 'view_team'.tr,
            icon: Icons.people_outline,
            color: theme.colorScheme.secondary,
            onTap: () => Get.toNamed('/org-team'),
            context: context,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentArticlesList(BuildContext context) {
    if (controller.recentArticles.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Text('no_recent_articles'.tr,
                style: Theme.of(context).textTheme.bodyMedium)),
      );
    }

    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: controller.recentArticles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final article = controller.recentArticles[index];
          return _buildArticleCard(context, article);
        },
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, RecentArticle article) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: theme.colorScheme.onSurface.withOpacity(0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Container(
              width: 100,
              height: 100,
              color: theme.colorScheme.surfaceVariant,
              child: _buildCoverImage(context, article.coverImage),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: theme.colorScheme.onSurface.withOpacity(0.95)),
                  ),
                  const SizedBox(height: 8),
                  // Date and Status
                  Row(
                    children: [
                      Text(
                          _formatArticleDate(
                              article.publishedAt ?? article.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.85))),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(article.status ?? 'draft')
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          (article.status ?? 'DRAFT').toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(article.status ?? 'draft'),
                          ),
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
    );
  }

  Widget _buildCoverImage(BuildContext context, String? imageData) {
    if (imageData == null || imageData.isEmpty) {
      return _buildPlaceholderImage(context);
    }

    // Check if it's a video file and show small video player
    final lowerData = imageData.toLowerCase();
    if (lowerData.endsWith('.mp4') ||
        lowerData.endsWith('.mov') ||
        lowerData.endsWith('.avi') ||
        lowerData.endsWith('.webm')) {
      // Construct full URL for video
      String videoUrl = imageData;
      if (!videoUrl.startsWith('http://') && !videoUrl.startsWith('https://')) {
        videoUrl = AppConfig.getImageUrl(imageData);
      }
      return SmallVideoPlayer(
        url: videoUrl,
        width: 100,
        height: 100,
      );
    }

    // Check if it's a base64 string
    if (imageData.startsWith('data:image')) {
      try {
        final base64String = imageData.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
          errorBuilder: (_, __, ___) => _buildPlaceholderImage(context),
        );
      } catch (e) {
        return _buildPlaceholderImage(context);
      }
    }

    // Check if it's a URL
    if (imageData.startsWith('http')) {
      return Image.network(
        imageData,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        errorBuilder: (_, __, ___) => _buildPlaceholderImage(context),
        loadingBuilder: (ctx, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }

    return _buildPlaceholderImage(context);
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceVariant,
      child: Icon(
        Icons.article,
        size: 40,
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }

  String _formatArticleDate(DateTime? date) {
    if (date == null) return '';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return Colors.green;
      case 'draft':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
