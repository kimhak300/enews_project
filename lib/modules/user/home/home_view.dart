import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/user/home/home_controller.dart';
import 'package:newshub/modules/user/user_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: const Text('Retry'),
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
                backgroundColor: Colors.white,
                expandedHeight: 60.h,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  title: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),

                        child: CircleAvatar(
                          child: Image.asset('assets/images/logo1.png',
                            width: 24.w, height: 24.h),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Enews',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.black87, size: 24.sp),
                    onPressed: () {
                      Get.find<UserController>().changeTab(1);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: Colors.black87, size: 24.sp),
                    onPressed: () {},
                  ),
                ],
              ),

              // Trending Topics Section
              if (controller.trendingArticles.isNotEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    ],
                  ),
                ),

              // Category Pills
              if (controller.categories.isNotEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 45.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: controller.categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildCategoryPill(
                            'All',
                            controller.selectedCategory.value == null,
                            () => controller.selectCategory(null),
                            Colors.blue,
                          );
                        }
                        final category = controller.categories[index - 1];
                        final isSelected = controller.selectedCategory.value?.id == category.id;
                        return _buildCategoryPill(
                          category.name,
                          isSelected,
                          () => controller.selectCategory(category),
                          _getCategoryColor(index),
                        );
                      },
                    ),
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 16.h)),

              // Featured Article
              if (controller.filteredArticles.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildFeaturedArticle(controller.filteredArticles.first),
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
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
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
                        return _buildArticleCard(article);
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


  Widget _buildCategoryPill(String name, bool isSelected, VoidCallback onTap, Color color) {
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
            color: isSelected ? null : Colors.grey[200],
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedArticle(article) {
    return Container(
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
                color: Colors.grey[300],
                image: null,
              ),
              child: _buildImage(
                article.coverImage ?? article.media?.first,
                fit: BoxFit.cover,
                placeholder: Center(child: Icon(Icons.image, size: 80.sp, color: Colors.grey[400])),
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
                    Colors.black.withOpacity(0.85),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            // Breaking Badge
            Positioned(
              top: 16.h,
              left: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flash_on, color: Colors.white, size: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'FEATURED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
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
                          CircleAvatar(
                            radius: 12.r,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 14.sp, color: Colors.blue),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            article.author!.displayName,
                            style: TextStyle(color: Colors.white, fontSize: 12.sp),
                          ),
                          SizedBox(width: 8.w),
                          const Text('•', style: TextStyle(color: Colors.white70)),
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          _formatDate(article.publishedAt ?? DateTime.now()),
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                        SizedBox(width: 8.w),
                        const Text('•', style: TextStyle(color: Colors.white70)),
                        SizedBox(width: 8.w),
                        Icon(Icons.schedule, color: Colors.white70, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          '5 min read',
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

  String _formatDate(DateTime date) {
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

  Widget _buildArticleCard(article) {
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
          // Navigate to article detail
          Get.toNamed('/article-detail', arguments: article.toJson());
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                Container(
                  height: 120.h,
                  width: 120.w,
                  color: Colors.grey[300],
                  child: coverImage != null
                      ? _buildImage(coverImage)
                      : Icon(
                          _getArticleIcon(article.type),
                          size: 36.sp,
                          color: Colors.grey[500],
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
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_circle, color: Colors.white, size: 12.sp),
                          SizedBox(width: 2.w),
                          Text(
                            'VIDEO',
                            style: TextStyle(
                              color: Colors.white,
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
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              catName,
                              style: TextStyle(
                                color: Colors.blue,
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
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    // Meta info
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 12.sp, color: Colors.grey[600]),
                        SizedBox(width: 4.w),
                        Text(
                          _formatDate(article.publishedAt ?? DateTime.now()),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(Icons.remove_red_eye_outlined, size: 12.sp, color: Colors.grey[600]),
                        SizedBox(width: 4.w),
                        Text(
                          '${article.viewCount ?? 0}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
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
}
