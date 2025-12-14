import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/user/home/home_controller.dart';
import 'package:newshub/modules/user/search/search_view.dart';
import 'package:newshub/modules/user/search/search_controller.dart'
    as user_search;
import 'package:newshub/modules/user/video/video_detail_view.dart';
import 'package:newshub/core/utils/video_helper.dart';
import 'package:newshub/modules/user/home/widgets/article_card_widget.dart';
import 'package:newshub/core/utils/article_helpers.dart';

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
        // if (controller.errorMessage.isNotEmpty && controller.articles.isEmpty) {
        //   return Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
        //         SizedBox(height: 16.h),
        //         Text(
        //           controller.errorMessage.value,
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //               fontSize: 14.sp,
        //               color: Theme.of(context).textTheme.bodyMedium?.color),
        //         ),
        //         SizedBox(height: 16.h),
        //         ElevatedButton(
        //           onPressed: controller.refresh,
        //           child: Text('retry'.tr),
        //         ),
        //       ],
        //     ),
        //   );
        // }
        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: CustomScrollView(
            slivers: [
              // Modern App Bar
              SliverAppBar(
                floating: true,
                snap: true,
                elevation: 0,
                backgroundColor:
                    Theme.of(context).appBarTheme.backgroundColor ??
                        Theme.of(context).colorScheme.primary,
                expandedHeight: 60.h,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  title: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset('assets/images/logo1.png',
                              width: 24.w, height: 24.h),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search,
                        color: Theme.of(context).appBarTheme.foregroundColor ??
                            Theme.of(context).colorScheme.onPrimary,
                        size: 24.sp),
                    onPressed: () {
                      // Ensure SearchController is registered before opening SearchView
                      if (!Get.isRegistered<user_search.SearchController>()) {
                        Get.put(user_search.SearchController());
                      }
                      Get.to(() => const SearchView());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined,
                        color: Theme.of(context).appBarTheme.foregroundColor ??
                            Theme.of(context).colorScheme.onPrimary,
                        size: 24.sp),
                    onPressed: () {},
                  ),
                ],
              ),
              // Inline search container that navigates to full SearchView
              // SliverToBoxAdapter(
              //   child: Container(
              //     padding: EdgeInsets.all(16.w),
              //     color: Theme.of(context).colorScheme.surface,
              //     child: Column(
              //       children: [],
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                          final isSelected =
                              controller.selectedCategory.value?.id ==
                                  category.id;
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
                    child: _buildFeaturedArticle(
                        context, controller.filteredArticles.first),
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
                        Icon(Icons.article_outlined,
                            size: 64.sp, color: Colors.grey),
                        SizedBox(height: 16.h),
                        Text(
                          'No articles available',
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
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
                        if (articleIndex ==
                            controller.filteredArticles.length) {
                          if (controller.hasMore) {
                            controller.loadMore();
                            return Padding(
                              padding: EdgeInsets.all(16.h),
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            );
                          }
                          return SizedBox(height: 100.h);
                        }

                        // Article card
                        final article =
                            controller.filteredArticles[articleIndex];
                        return ArticleCardWidget(
                          article: article,
                          onTap: () {
                            // If this is a video and has media, open video detail; otherwise article detail
                            try {
                              if (article.type == 'video' &&
                                  article.media != null &&
                                  article.media!.isNotEmpty) {
                                final raw = article.media!.first;
                                final normalized = normalizeVideoSource(raw);
                                if (normalized.isNotEmpty) {
                                  Get.to(() => UserVideoDetailView(
                                      videoUrl: normalized, title: article.title));
                                  return;
                                }
                              }
                            } catch (_) {
                              // Fall back to article detail on any error
                            }

                            Get.toNamed('/article-detail', arguments: article.toJson());
                          },
                        );
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

  Widget _buildCategoryPill(BuildContext context, String name, bool isSelected,
      VoidCallback onTap, Color color) {
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
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                color: isSelected
                    ? (Theme.of(context).colorScheme.onPrimary)
                    : (Theme.of(context).textTheme.bodyMedium?.color ??
                        Theme.of(context).colorScheme.onBackground),
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
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
            color: isSelected
                ? theme.colorScheme.onPrimary
                : (theme.textTheme.bodyMedium?.color ?? Colors.black),
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
        } else if (article.coverImage != null &&
            article.coverImage!.isNotEmpty) {
          videoUrl = article.coverImage;
        }

        if (isVideo && videoUrl != null && videoUrl.isNotEmpty) {
          final normalized = normalizeVideoSource(videoUrl);
          if (normalized.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => UserVideoDetailView(
                      videoUrl: normalized, title: article.title)),
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
                child: ArticleHelpers.buildImage(
                  article.coverImage ?? article.media?.first,
                  fit: BoxFit.cover,
                  placeholder: Center(
                      child: Icon(Icons.image,
                          size: 80.sp, color: Theme.of(context).disabledColor)),
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
                              backgroundImage:
                                  (article.author!.avatarUrl != null &&
                                          article.author!.avatarUrl!.isNotEmpty)
                                      ? NetworkImage(article.author!.avatarUrl!)
                                      : null,
                              child: (article.author!.avatarUrl == null ||
                                      article.author!.avatarUrl!.isEmpty)
                                  ? Text(
                                      article.author!.name.isNotEmpty
                                          ? article.author!.name[0]
                                              .toUpperCase()
                                          : 'U',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 8.w),
                            // Author name
                            Text(
                              article.author!.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6.w),
                              // Role badge
                              Builder(builder: (ctx) {
                                final bg = ArticleHelpers.getRoleBadgeColor(article.author!.primaryRole, ctx);
                                final fg = ArticleHelpers.getRoleBadgeTextColor(article.author!.primaryRole, ctx);
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: bg,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    ArticleHelpers.getRoleLabel(article.author!.primaryRole),
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold,
                                      color: fg,
                                    ),
                                  ),
                                );
                              }),
                            SizedBox(width: 8.w),
                          ],
                              Icon(Icons.access_time,
                              size: 12.sp, color: Theme.of(context).disabledColor),
                          SizedBox(width: 4.w),
                          Text(
                            ArticleHelpers.formatDate(
                              article.publishedAt ??
                                  article.createdAt ??
                                  article.updatedAt,
                            ),
                            style: TextStyle(
                              color: Theme.of(context).disabledColor, fontSize: 12.sp),
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

  Color _getCategoryColor(int index) {
    return ArticleHelpers.getCategoryColor(index);
  }
}
