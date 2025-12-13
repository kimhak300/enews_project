import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/user/home/home_controller.dart';
import 'package:newshub/modules/user/search/search_view.dart';
import 'package:newshub/modules/user/search/search_controller.dart' as user_search;
import 'package:newshub/modules/user/video/video_detail_view.dart';
import 'package:newshub/core/utils/video_helper.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Theme.of(context).textTheme.bodyMedium?.color),
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

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: CustomScrollView(
            slivers: [
              // Modern App Bar
              SliverAppBar(
                
                floating: true,
                snap: true,
                elevation: 0,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.primary,
                expandedHeight: 60.h,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  title: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset('assets/images/logo1.png', width: 24.w, height: 24.h),
                        ),
                      ),
                    ],
                  ),
                ),
                
                actions: [
                  IconButton(
                    icon: Icon(Icons.search, color: Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onPrimary, size: 24.sp),
                    onPressed: () {
                      // Ensure SearchController is registered before opening SearchView
                      if (!Get.isRegistered<user_search.SearchController>()) {
                        Get.put(user_search.SearchController());
                      }
                      Get.to(() => const SearchView());

                    },
                    
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onPrimary, size: 24.sp),
                    onPressed: () {},
                  ),
                ],
              ),
              // Inline search container that navigates to full SearchView
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: [
                    ],
                  ),
                ),
              ),

              // Trending / Categories Section
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    ),
                    SizedBox(
                      height: 45.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: controller.categories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _buildCategoryPill(
                              context,
                              'all'.tr,
                              controller.selectedCategory.value == null,
                              () => controller.selectCategory(null),
                              Theme.of(context).colorScheme.primary,
                            );
                          }
                          final category = controller.categories[index - 1];
                          final isSelected = controller.selectedCategory.value?.id == category.id;
                          return _buildCategoryPill(
                            context,
                            category.name,
                            isSelected,
                            () => controller.selectCategory(category),
                            _getCategoryColor(index),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 16.h)),

              // Featured Article
              if (controller.filteredArticles.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildFeaturedArticle(context, controller.filteredArticles.first),
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 16.h)),

              // Articles List
              if (controller.filteredArticles.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.article_outlined, size: 64.sp, color: Colors.grey),
                        SizedBox(height: 16.h),
                        Text(
                          'No articles available',
                          style: TextStyle(fontSize: 16.sp, color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // Skip the first article (already shown as featured)
                        if (index == 0) return const SizedBox.shrink();
                        
                        // Adjust index since we skip first article
                        final articleIndex = index;
                        
                        // Loading indicator at the end
                        if (articleIndex == controller.filteredArticles.length) {
                          if (controller.hasMore) {
                            controller.loadMore();
                            return Padding(
                              padding: EdgeInsets.all(16.h),
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          }
                          return SizedBox(height: 100.h);
                        }
                        
                        // Article card
                        final article = controller.filteredArticles[articleIndex];
                        return _buildArticleCard(context, article);
                      },
                      childCount: controller.filteredArticles.length + 1,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }


  Widget _buildCategoryPill(BuildContext context, String name, bool isSelected, VoidCallback onTap, Color color) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: [color, color.withOpacity(0.7)])
                : null,
            color: isSelected ? null : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Text(
            name,
            style: TextStyle(
              color: isSelected ? (Theme.of(context).colorScheme.onPrimary) : (Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).colorScheme.onBackground),
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String status) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == status;
      final theme = Theme.of(context);
      return ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.colorScheme.onPrimary : (theme.textTheme.bodyMedium?.color ?? Colors.black),
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => controller.filterByStatus(status),
        selectedColor: theme.colorScheme.primary,
        backgroundColor: theme.cardColor,
      );
    });
  }

  Widget _buildFeaturedArticle(BuildContext context, article) {
    return GestureDetector(
      onTap: () {
        // If this is a video article and has a video URL, open video view
        final isVideo = (article.type ?? '') == 'video';
        String? videoUrl;
        if (article.media != null && article.media!.isNotEmpty) {
          final first = article.media!.first;
          if (first is String) videoUrl = first;
        } else if (article.coverImage != null && article.coverImage!.isNotEmpty) {
          videoUrl = article.coverImage;
        }

        if (isVideo && videoUrl != null && videoUrl.isNotEmpty) {
          final normalized = normalizeVideoSource(videoUrl);
          if (normalized.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserVideoDetailView(videoUrl: normalized, title: article.title)),
            );
            return;
          }
        }

        // Default: open article detail via named route so binding runs
        final args = article.toJson();
        Get.toNamed('/article-detail', arguments: args);
      },
      child: Container(
        height: 280.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
          children: [
            // Image
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                image: null,
              ),
              child: _buildImage(
                article.coverImage ?? article.media?.first,
                fit: BoxFit.cover,
                placeholder: Center(child: Icon(Icons.image, size: 80.sp, color: Theme.of(context).disabledColor)),
              ),
            ),
            // Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.85),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        if (article.author != null) ...[
                          // Avatar
                          CircleAvatar(
                            radius: 14.r,
                            backgroundColor: Colors.white,
                            backgroundImage: (article.author!.avatarUrl != null && article.author!.avatarUrl!.isNotEmpty)
                                ? NetworkImage(article.author!.avatarUrl!)
                                : null,
                            child: (article.author!.avatarUrl == null || article.author!.avatarUrl!.isEmpty)
                                ? Text(
                                    article.author!.name.isNotEmpty ? article.author!.name[0].toUpperCase() : 'U',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(width: 8.w),
                          // Author name
                          Text(
                            article.author!.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          // Role badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: _getRoleBadgeColor(article.author!.primaryRole),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              _getRoleLabel(article.author!.primaryRole),
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Icon(Icons.access_time, size: 12.sp, color: Colors.white70),
                        SizedBox(width: 4.w),
                        Text(
                          _formatDate(
                            (article.publishedAt ?? article.createdAt ?? article.updatedAt) as DateTime?,
                          ),
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  // Unified image builder supporting URLs and base64 data URIs
  Widget _buildImage(String? src, {BoxFit fit = BoxFit.cover, Widget? placeholder}) {
    if (src == null || src.isEmpty) {
      return placeholder ?? const SizedBox();
    }

    if (src.startsWith('data:image')) {
      try {
        final bytes = base64Decode(src.split(',').last);
        return Image.memory(bytes, fit: fit, width: double.infinity, height: double.infinity,
            errorBuilder: (_, __, ___) => placeholder ?? const SizedBox());
      } catch (_) {
        return placeholder ?? const SizedBox();
      }
    }

    return Image.network(
      src,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => placeholder ?? const SizedBox(),
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[index % colors.length];
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

  String _formatData(int minutes) {
    // Use localization key `min_read` (e.g. "min read") and format with minutes
    return '$minutes ${'min_read'.tr}';
  }
  Widget _buildArticleCard(BuildContext context, article) {
    final theme = Theme.of(context);
    // Get cover image from media list or coverImage
    String? coverImage;
    if (article.media != null && article.media!.isNotEmpty) {
      coverImage = article.media!.first;
    } else if (article.coverImage != null && article.coverImage!.isNotEmpty) {
      coverImage = article.coverImage;
    }

    final categories = article.categories ?? [];

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          // If this is a video and has media, open video detail; otherwise article detail
          try {
            if (article.type == 'video' && article.media != null && article.media!.isNotEmpty) {
              final raw = article.media!.first as String;
              final normalized = normalizeVideoSource(raw);
              if (normalized.isNotEmpty) {
                Get.to(() => UserVideoDetailView(videoUrl: normalized, title: article.title));
                return;
              }
            }
          } catch (_) {
            // Fall back to article detail on any error
          }

          Get.toNamed('/article-detail', arguments: article.toJson());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author profile header
            if (article.author != null)
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      backgroundImage: (article.author!.avatarUrl != null && article.author!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(article.author!.avatarUrl!)
                          : null,
                      child: (article.author!.avatarUrl == null || article.author!.avatarUrl!.isEmpty)
                          ? Text(
                              article.author!.name.isNotEmpty ? article.author!.name[0].toUpperCase() : 'U',
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
                                  article.author!.name,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.textTheme.bodyLarge?.color,
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
                                  color: _getRoleBadgeColor(article.author!.primaryRole),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  _getRoleLabel(article.author!.primaryRole),
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
                              Icon(Icons.access_time, size: 11.sp, color: theme.textTheme.bodySmall?.color),
                              SizedBox(width: 4.w),
                              Text(
                                _formatDate(
                                  (article.publishedAt ?? article.createdAt ?? article.updatedAt) as DateTime?,
                                ),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: theme.textTheme.bodySmall?.color,
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
            // Article content with image and text
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
                              _getArticleIcon(article.type),
                              size: 36.sp,
                              color: Theme.of(context).disabledColor,
                            ),
                    ),
                    // Type badge (Video/Article badge)
                    if (article.type == 'video')
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_circle, color: Theme.of(context).colorScheme.onError, size: 12.sp),
                              SizedBox(width: 4.w),
                              Text(
                                'video'.tr.toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onError,
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
                // Content
                Expanded(
                  child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories
                    if (categories.isNotEmpty)
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children: categories.take(2).map<Widget>((cat) {
                          String catName;
                          if (cat is String) {
                            catName = cat;
                          } else if (cat is Map) {
                            catName = cat['name'] ?? 'Category';
                          } else {
                            // Handle CategoryModel object
                            catName = cat.name ?? 'Category';
                          }
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    catName,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                        }).toList(),
                      ),
                    SizedBox(height: 6.h),
                    // Title
                    Text(
                      article.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface.withOpacity(0.95),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    // Meta info
                    Row(
                      children: [
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
            ),
          ],
        ),
      ],
    ),
      ),
    );
  }

  IconData _getArticleIcon(String? type) {
    switch (type) {
      case 'video':
        return Icons.play_circle_outline;
      case 'news_feed':
        return Icons.newspaper;
      case 'article':
      default:
        return Icons.article_outlined;
    }
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
