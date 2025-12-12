import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/app/config/api_constants.dart';
import 'package:newshub/modules/user/search/search_controller.dart' as user_search;
import 'package:newshub/modules/user/search/search_small_video_player.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<user_search.SearchController>()
        ? Get.find<user_search.SearchController>()
        : Get.put(user_search.SearchController());

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
                // Search Bar with back button
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: Theme.of(context).iconTheme.color),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: TextField(
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
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Filters Row
                Row(
                  children: [
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
    // Choose cover / video URL from model (handle String or Map entries)
    String? coverImage;
    String? videoUrl;
    String? posterUrl;

    if (article.coverImage != null && article.coverImage is String && (article.coverImage as String).isNotEmpty) {
      coverImage = article.coverImage as String;
    }

    if (article.media != null && article.media is List && (article.media as List).isNotEmpty) {
      final first = (article.media as List).first;
      if (first is String) {
        // Could be an image or a direct video URL
        if (article.type == 'video') {
          videoUrl ??= first;
        } else {
          coverImage ??= first;
        }
      } else if (first is Map) {
        // Try common keys that might contain URLs
        final m = first;
        final candidateVideo = (m['url'] ?? m['video'] ?? m['src'] ?? m['link'] ?? m['path'])?.toString();
        final candidatePoster = (m['poster'] ?? m['thumbnail'] ?? m['thumb'] ?? m['cover'])?.toString();
        if (candidateVideo != null && candidateVideo.isNotEmpty) {
          if (article.type == 'video') {
            videoUrl ??= candidateVideo;
            posterUrl ??= candidatePoster;
          } else {
            coverImage ??= candidateVideo;
          }
        } else if (candidatePoster != null && candidatePoster.isNotEmpty) {
          coverImage ??= candidatePoster;
        }
      }
    }

    // If article explicitly marked as video but we don't have videoUrl,
    // fall back to coverImage if it's probably a video URL string.
    if (article.type == 'video' && videoUrl == null && coverImage != null) {
      videoUrl = coverImage;
      coverImage = null; // coverImage holds poster/thumbnail; clear to avoid double-using
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 0,
      child: InkWell(
        onTap: () {
          // Navigate to article detail
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                width: 96.w,
                height: 96.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: (article.type == 'video' && (videoUrl != null || coverImage != null))
                        ? SearchSmallVideoPlayer(
                            url: videoUrl ?? coverImage ?? '',
                            poster: posterUrl ?? coverImage,
                            width: 96,
                            height: 96,
                          )
                        : (coverImage != null
                            ? _buildArticleImage(coverImage, height: 96.h)
                            : Center(
                                child: Icon(
                                  Icons.article_outlined,
                                  size: 36.sp,
                                  color: theme.disabledColor,
                                ),
                              )),
                  ),
              ),
              SizedBox(width: 12.w),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.categories != null && (article.categories as List).isNotEmpty)
                      Builder(builder: (context) {
                        final List cats = (article.categories as List);
                        final dynamic firstCat = cats.first;
                        String catName = 'Category';
                        if (firstCat is String) {
                          catName = firstCat;
                        } else if (firstCat is Map) {
                          catName = (firstCat['name'] ?? 'Category') as String;
                        } else if (firstCat != null) {
                          try {
                            // Try dynamic property access (e.g., CategoryModel.name)
                            final dyn = firstCat as dynamic;
                            final name = dyn.name;
                            if (name != null) {
                              catName = name as String;
                            } else if (dyn is Map && dyn['name'] != null) {
                              catName = dyn['name'] as String;
                            }
                          } catch (_) {
                            catName = 'Category';
                          }
                        }

                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          margin: EdgeInsets.only(bottom: 6.h),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            catName,
                            style: TextStyle(color: theme.colorScheme.primary, fontSize: 11.sp, fontWeight: FontWeight.w600),
                          ),
                        );
                      }),
                    Text(
                      article.title ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 15.sp, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.95)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (article.excerpt != null)
                      Padding(
                        padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
                        child: Text(
                          article.excerpt ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13.sp, color: theme.colorScheme.onSurface.withOpacity(0.72)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 12.sp, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                        SizedBox(width: 4.w),
                        Text(
                          _formatDate((article.publishedAt ?? article.createdAt ?? article.updatedAt) as DateTime?),
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 11.sp),
                        ),
                        SizedBox(width: 8.w),
                        Icon(Icons.remove_red_eye_outlined, size: 12.sp, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                        SizedBox(width: 4.w),
                        Text(
                          '${article.viewCount ?? 0}',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7), fontSize: 11.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()}y ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()}mo ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildArticleImage(String imageData, {double? height}) {
    // Handle base64 images
    if (imageData.startsWith('data:image')) {
      try {
        final base64String = imageData.split(',').last;
        final Uint8List bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: double.infinity,
          height: height ?? 180.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: double.infinity,
            height: height ?? 180.h,
            color: Colors.grey[300],
            child: Icon(Icons.broken_image, size: 64.sp, color: Colors.grey),
          ),
        );
      } catch (e) {
        return Container(
          width: double.infinity,
          height: height ?? 180.h,
          color: Colors.grey[300],
          child: Icon(Icons.article, size: 64.sp, color: Colors.grey),
        );
      }
    }
    
    // Handle regular URL images
    return Image.network(
      _getImageUrl(imageData),
      width: double.infinity,
      height: height ?? 180.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: double.infinity,
        height: height ?? 180.h,
        color: Colors.grey[300],
        child: Icon(Icons.broken_image, size: 64.sp, color: Colors.grey),
      ),
    );
  }
}
