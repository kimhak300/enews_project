import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/app/config/api_constants.dart';
import 'package:newshub/modules/user/search/search_controller.dart' as user_search;
import 'package:newshub/modules/user/search/search_small_video_player.dart';
import 'package:newshub/modules/user/video/video_detail_view.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<user_search.SearchController>()
        ? Get.find<user_search.SearchController>()
        : Get.put(user_search.SearchController());

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Search Header
          Container(
            color: theme.cardColor,
            padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 16.h),
            child: Column(
              children: [
                // Search Bar with back button
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: theme.iconTheme.color),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.searchTextController,
                        onChanged: controller.search,
                        decoration: InputDecoration(
                              hintText: 'search_news'.tr,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: controller.clearSearch,
                                )
                              : const SizedBox()),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceVariant,
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
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.filter_list, size: 18.sp),
                                SizedBox(width: 6.w),
                                Flexible(
                                       child: Text(
                                         controller.selectedCategory.value ?? 'all'.tr,
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
                                   child: Text('all'.tr,
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
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.sort, size: 18.sp),
                                SizedBox(width: 6.w),
                                      Text(
                                       controller.selectedSort.value == 'latest'
                                           ? 'sort_latest'.tr
                                           : controller.selectedSort.value == 'popular'
                                               ? 'sort_popular'.tr
                                               : 'sort_oldest'.tr,
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
                                   child: Text('sort_latest'.tr, style: TextStyle(fontSize: 13.sp)),
                                 ),
                                 PopupMenuItem(
                                   value: 'popular',
                                   child: Text('sort_popular'.tr, style: TextStyle(fontSize: 13.sp)),
                                 ),
                                 PopupMenuItem(
                                   value: 'oldest',
                                   child: Text('sort_oldest'.tr, style: TextStyle(fontSize: 13.sp)),
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
                      Icon(Icons.error_outline, size: 64.sp, color: theme.colorScheme.error),
                      SizedBox(height: 16.h),
                      Text(controller.errorMessage.value, style: theme.textTheme.bodyMedium),
                      SizedBox(height: 16.h),
                           ElevatedButton(
                             onPressed: controller.refresh,
                             child: Text('retry'.tr),
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
                      Icon(Icons.search_off, size: 64.sp, color: theme.disabledColor),
                      SizedBox(height: 16.h),
                          Obx(() => Text(
                            controller.searchQuery.isNotEmpty
                                ? 'no_articles_for'.trParams({'query': controller.searchQuery.value})
                                : 'no_articles'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          )),
                      if (controller.searchQuery.isNotEmpty ||
                          controller.selectedCategory.value != null)
                        Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: ElevatedButton(
                                onPressed: () {
                                  controller.clearSearch();
                                  controller.setCategory(null);
                                },
                                child: Text('clear_filters'.tr),
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
                            'articles_found'.trParams({'count': controller.filteredArticles.length.toString()}),
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
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
          // If video article -> open video detail, else open article detail
          final isVideo = (article.type ?? '') == 'video';
          final mediaList = article.media as List?;
          String? videoUrl;
          if (mediaList != null && mediaList.isNotEmpty) {
            final first = mediaList.first;
            if (first is String) videoUrl = first;
            else if (first is Map) videoUrl = (first['url'] ?? first['video'] ?? first['src'] ?? first['path'])?.toString();
          }

          if (isVideo && (videoUrl != null && videoUrl.isNotEmpty)) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserVideoDetailView(videoUrl: videoUrl!, title: article.title)),
            );
            return;
          }

          // Otherwise open user article detail (pass raw json map)
          final Map<String, dynamic> args = article is Map ? Map<String, dynamic>.from(article) : (article.toJson());
          Get.toNamed('/article-detail', arguments: args);
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
          errorBuilder: (context, error, stackTrace) {
            final theme = Theme.of(context);
            return Container(
              width: double.infinity,
              height: height ?? 180.h,
              color: theme.colorScheme.surfaceVariant,
              child: Icon(Icons.broken_image, size: 64.sp, color: theme.disabledColor),
            );
          },
        );
      } catch (e) {
        final theme = Theme.of(Get.context!);
        return Container(
          width: double.infinity,
          height: height ?? 180.h,
          color: theme.colorScheme.surfaceVariant,
          child: Icon(Icons.article, size: 64.sp, color: theme.disabledColor),
        );
      }
    }
    
    // Handle regular URL images
    return Image.network(
      _getImageUrl(imageData),
      width: double.infinity,
      height: height ?? 180.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        final theme = Theme.of(context);
        return Container(
          width: double.infinity,
          height: height ?? 180.h,
          color: theme.colorScheme.surfaceVariant,
          child: Icon(Icons.broken_image, size: 64.sp, color: theme.disabledColor),
        );
      },
    );
  }
}
