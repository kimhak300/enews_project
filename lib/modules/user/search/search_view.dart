import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/app/config/api_constants.dart';
import 'package:newshub/modules/user/search/search_controller.dart' as user_search;

class SearchView extends GetView<user_search.SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Search Header
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 16.h),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: controller.searchTextController,
                  onChanged: controller.search,
                  decoration: InputDecoration(
                    hintText: 'Search articles...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: controller.clearSearch,
                          )
                        : const SizedBox()),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Filters Row
                Row(
                  children: [
                    // Category Filter
                    Expanded(
                      child: Obx(() {
                        final categories = controller.allCategories;
                        return PopupMenuButton<String?>(
                          onSelected: controller.setCategory,
                          offset: Offset(0, 40.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.filter_list, size: 18.sp),
                                SizedBox(width: 6.w),
                                Flexible(
                                  child: Text(
                                    controller.selectedCategory.value ?? 'All Categories',
                                    style: TextStyle(fontSize: 13.sp),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(Icons.arrow_drop_down, size: 18.sp),
                              ],
                            ),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem<String?>(
                              value: null,
                              child: Text('All Categories',
                                  style: TextStyle(fontSize: 13.sp)),
                            ),
                            ...categories.map(
                              (cat) => PopupMenuItem<String?>(
                                value: cat,
                                child: Text(cat, style: TextStyle(fontSize: 13.sp)),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(width: 12.w),
                    // Sort Filter
                    Obx(() => PopupMenuButton<String>(
                          onSelected: controller.setSort,
                          offset: Offset(0, 40.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.sort, size: 18.sp),
                                SizedBox(width: 6.w),
                                Text(
                                  controller.selectedSort.value == 'latest'
                                      ? 'Latest'
                                      : controller.selectedSort.value == 'popular'
                                          ? 'Popular'
                                          : 'Oldest',
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                SizedBox(width: 4.w),
                                Icon(Icons.arrow_drop_down, size: 18.sp),
                              ],
                            ),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'latest',
                              child: Text('Latest', style: TextStyle(fontSize: 13.sp)),
                            ),
                            PopupMenuItem(
                              value: 'popular',
                              child: Text('Popular', style: TextStyle(fontSize: 13.sp)),
                            ),
                            PopupMenuItem(
                              value: 'oldest',
                              child: Text('Oldest', style: TextStyle(fontSize: 13.sp)),
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.articles.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty &&
                  controller.articles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                      SizedBox(height: 16.h),
                      Text(controller.errorMessage.value),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: controller.refresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.filteredArticles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64.sp, color: Colors.grey),
                      SizedBox(height: 16.h),
                      Text(
                        controller.searchQuery.isNotEmpty
                            ? 'No articles found for "${controller.searchQuery.value}"'
                            : 'No articles available',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (controller.searchQuery.isNotEmpty ||
                          controller.selectedCategory.value != null)
                        Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: ElevatedButton(
                            onPressed: () {
                              controller.clearSearch();
                              controller.setCategory(null);
                            },
                            child: const Text('Clear Filters'),
                          ),
                        ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Results Count
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        '${controller.filteredArticles.length} article${controller.filteredArticles.length != 1 ? 's' : ''} found',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Articles List
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: controller.filteredArticles.length,
                        itemBuilder: (context, index) {
                          final article = controller.filteredArticles[index];
                          print(article..media);
                          return _buildArticleCard(context, article);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, article) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to article detail
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (article.coverImage != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: _buildArticleImage(article.coverImage!),
              ),
            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  if (article.categories != null && article.categories!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        article.categories!.first.name,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, fontSize: 11.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  // Title
                  Text(
                    article.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.95)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (article.excerpt != null)
                    SizedBox(height: 8.h),
                  if (article.excerpt != null)
                    Text(
                      article.excerpt!,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13.sp, color: theme.colorScheme.onSurface.withOpacity(0.72)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 12.h),
                  // Meta Info
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 16.sp, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      SizedBox(width: 4.w),
                      Text('${article.viewCount ?? 0}', style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: theme.colorScheme.onSurface.withOpacity(0.72))),
                      SizedBox(width: 16.w),
                      Icon(Icons.thumb_up, size: 16.sp, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      SizedBox(width: 4.w),
                      Text('${article.likeCount ?? 0}', style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: theme.colorScheme.onSurface.withOpacity(0.72))),
                      SizedBox(width: 16.w),
                      Icon(Icons.comment, size: 16.sp, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      SizedBox(width: 4.w),
                      Text('${article.commentCount ?? 0}', style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: theme.colorScheme.onSurface.withOpacity(0.72))),
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

  String _getImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    return '${ApiConstants.mediaBaseUrl}${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}';
  }

  Widget _buildArticleImage(String imageData) {
    // Handle base64 images
    if (imageData.startsWith('data:image')) {
      try {
        final base64String = imageData.split(',').last;
        final Uint8List bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: double.infinity,
          height: 180.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: double.infinity,
            height: 180.h,
            color: Colors.grey[300],
            child: Icon(Icons.broken_image, size: 64.sp, color: Colors.grey),
          ),
        );
      } catch (e) {
        return Container(
          width: double.infinity,
          height: 180.h,
          color: Colors.grey[300],
          child: Icon(Icons.article, size: 64.sp, color: Colors.grey),
        );
      }
    }
    
    // Handle regular URL images
    return Image.network(
      _getImageUrl(imageData),
      width: double.infinity,
      height: 180.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: double.infinity,
        height: 180.h,
        color: Colors.grey[300],
        child: Icon(Icons.broken_image, size: 64.sp, color: Colors.grey),
      ),
    );
  }
}
