import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/data/models/article_model.dart';
import 'package:newshub/core/utils/article_helpers.dart';

/// Shared article card widget for home, video, and hot news views
class ArticleCardWidget extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback? onTap;
  final Widget? customBadge;
  final bool showTypeBadge;
  final String? badgeText;
  final Color? badgeColor;
  final IconData? badgeIcon;

  const ArticleCardWidget({
    super.key,
    required this.article,
    this.onTap,
    this.customBadge,
    this.showTypeBadge = true,
    this.badgeText,
    this.badgeColor,
    this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Profile Header
            if (article.author != null)
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      backgroundImage: (article.author!.avatarUrl != null &&
                              article.author!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(article.author!.avatarUrl!)
                          : null,
                      child: (article.author!.avatarUrl == null ||
                              article.author!.avatarUrl!.isEmpty)
                          ? Text(
                              article.author!.name.isNotEmpty
                                  ? article.author!.name[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 10.w),
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
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              // Role badge
                              Builder(builder: (ctx) {
                                final bg = ArticleHelpers.getRoleBadgeColor(
                                    article.author!.primaryRole, ctx);
                                final fg = ArticleHelpers.getRoleBadgeTextColor(
                                    article.author!.primaryRole, ctx);
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: bg,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    ArticleHelpers.getRoleLabel(
                                        article.author!.primaryRole),
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold,
                                      color: fg,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          // Time posted
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12.sp,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                ArticleHelpers.formatDate(
                                  article.publishedAt ??
                                      article.createdAt ??
                                      article.updatedAt,
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
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.r),
                        ),
                        child: coverImage != null
                            ? ArticleHelpers.buildImage(coverImage)
                            : Icon(
                                ArticleHelpers.getArticleIcon(article.type),
                                size: 40.sp,
                                color: theme.disabledColor,
                              ),
                      ),
                    ),
                    // Custom badge or type badge
                    if (customBadge != null)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: customBadge!,
                      )
                    else if (showTypeBadge &&
                        (article.type == 'video' ||
                            badgeText != null))
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: badgeColor ?? theme.colorScheme.error,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (badgeIcon != null || article.type == 'video')
                                Icon(
                                  badgeIcon ?? Icons.play_circle,
                                  color: Colors.white,
                                  size: 14.sp,
                                ),
                              if (badgeIcon != null || article.type == 'video')
                                SizedBox(width: 4.w),
                              Text(
                                badgeText ??
                                    (article.type == 'video'
                                        ? 'video'.tr.toUpperCase()
                                        : ''),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
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
                            children: categories.take(2).map<Widget>((dynamic cat) {
                              String catName = 'Category';
                              try {
                                if (cat is String) {
                                  catName = cat;
                                } else if (cat != null && cat.name != null) {
                                  // Handle CategoryModel object
                                  catName = cat.name.toString();
                                }
                              } catch (e) {
                                catName = 'Category';
                              }
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Text(
                                  catName,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        if (categories.isNotEmpty) SizedBox(height: 8.h),
                        
                        // Title
                        Text(
                          article.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        
                        // View count
                        Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye_outlined,
                              size: 13.sp,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${article.viewCount ?? 0}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                                fontSize: 12.sp,
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
          ],
        ),
      ),
    );
  }
}
