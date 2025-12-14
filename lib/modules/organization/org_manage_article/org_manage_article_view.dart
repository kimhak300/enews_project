import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/organization/org_manage_article/org_article_widget.dart';
import 'package:newshub/modules/organization/org_manage_article/org_manage_article_controller.dart';
import 'package:newshub/app/utils/image_utils.dart';

class OrgManageArticleView extends GetView<OrgManageArticleController> {
  const OrgManageArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('manage_articles'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.articles.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                SizedBox(height: 16.h),
                Text(controller.errorMessage.value),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.refresh(),
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Search and Filter Bar (kept)
            Container(
              padding: EdgeInsets.all(16.w),
              color: theme.colorScheme.surface,
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'search_articles'.tr,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.12)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    onChanged: controller.searchArticles,
                  ),
                  SizedBox(height: 12.h),
                  // Status Filter (wrapped to prevent overflow)
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildFilterChip(context, 'all'.tr, 'all'),
                      _buildFilterChip(context, 'published'.tr, 'published'),
                      _buildFilterChip(context, 'draft'.tr, 'draft'),
                      _buildFilterChip(context, 'archived'.tr, 'archived'),
                    ],
                  ),
                ],
              ),
            ),

            // Article List
            Expanded(
              child: controller.filteredArticles.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined,
                              size: 64.sp, color: Colors.grey),
                          SizedBox(height: 16.h),
                          Text(
                            'no_articles_found'.tr,
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: controller.refresh,
                      child: ListView.builder(
                        padding: EdgeInsets.all(AppSpacing.paddingXS),
                        itemCount: controller.filteredArticles.length,
                        itemBuilder: (context, index) {
                          final article = controller.filteredArticles[index];
                          return OrgArticleWidget(
                            title: article.title,
                            subtitle: article.subtitle ?? '',
                            categories: (article.categories ?? [])
                                .map((c) => c.name)
                                .toList(),
                            images: article.media,
                            articleData: article.toJson(),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToCreateArticle,
        child: const Icon(Icons.add),
        
      ),
      
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Obx(() {
      final isSelected = controller.selectedStatus.value == value;
      return FilterChip(
        label: Text(label, style: theme.textTheme.bodySmall),
        selected: isSelected,
        onSelected: (_) => controller.setStatusFilter(value),
        backgroundColor: theme.colorScheme.surfaceVariant,
        selectedColor: theme.colorScheme.primaryContainer,
        checkmarkColor: theme.colorScheme.onPrimary,
      );
    });
  }

  Widget _buildArticleCard(BuildContext context, Map<String, dynamic> article) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.navigateToEditArticle(article['id']),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Article Thumbnail
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Builder(
                  builder: (_) {
                    final img =
                        resolveImageProvider(article['cover_image'] as String?);
                    if (img != null) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image(
                          image: img,
                          width: 80.w,
                          height: 80.w,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(Icons.article,
                              size: 32.sp,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7)),
                        ),
                      );
                    }
                    return Icon(Icons.article,
                        size: 32.sp,
                        color: theme.colorScheme.onSurface.withOpacity(0.7));
                  },
                ),
              ),
              SizedBox(width: 12.w),

              // Article Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title'] ?? 'untitled'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16.sp, fontWeight: FontWeight.w600) ??
                          TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: (article['status'] == 'published'
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.secondary)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            article['status'] ?? 'draft',
                            style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 11.sp,
                                  color: article['status'] == 'published'
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ) ??
                                TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Views Count
                        Icon(Icons.visibility,
                            size: 14.sp,
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.7)),
                        SizedBox(width: 4.w),
                        Text(
                          '${article['views_count'] ?? 0}',
                          style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7)) ??
                              TextStyle(
                                  fontSize: 12.sp,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions Menu
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    controller.navigateToEditArticle(article['id']);
                  } else if (value == 'delete') {
                    _showDeleteDialog(article);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit,
                            size: 20, color: theme.colorScheme.onSurface),
                        SizedBox(width: 8),
                        Text('edit'.tr, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete,
                            size: 20, color: theme.colorScheme.error),
                        SizedBox(width: 8),
                        Text('delete'.tr,
                            style: TextStyle(color: theme.colorScheme.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> article) {
    Get.dialog(
      AlertDialog(
        title: Text('delete_article'.tr),
        content: Text('delete_article_confirmation'.tr.replaceAll('{title}', article['title'] ?? '')),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();

              try {
                await controller.deleteArticle(article['id']);
                Get.snackbar(
                  'success'.tr,
                  'article_deleted_successfully'.tr,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e) {
                Get.snackbar(
                  'error'.tr,
                  'failed_to_delete_article'.tr,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}
