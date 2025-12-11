import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:newshub/data/models/article_model.dart';
import 'package:newshub/modules/user/bookmark/bookmark_controller.dart';

class BookmarkView extends GetView<BookmarkController> {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text('saved_articles'.tr),
        backgroundColor: theme.appBarTheme.backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refresh,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.35)),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.bookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 80, color: theme.colorScheme.onSurface.withOpacity(0.35)),
                 SizedBox(height: 16),
                Text(
                  'no_saved_articles_yet'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                 SizedBox(height: 8),
                Text(
                  'articles_you_save_will_appear_here'.tr,
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchBookmarks(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.bookmarks.length,
            itemBuilder: (context, index) {
              return _buildBookmarkCard(context, controller.bookmarks[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildBookmarkCard(BuildContext context, ArticleModel article) {
    final theme = Theme.of(context);
    return Dismissible(
      key: Key(article.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
      confirmDismiss: (direction) async {
        controller.showRemoveConfirmation(article);
        return false;
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _openArticle(article),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildThumbnail(context, article),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.categories != null &&
                          article.categories!.isNotEmpty)
                        Text(
                          article.categories!.first.name,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        article.title,
                        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.bold) ??
                            const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Add excerpt/description
                      if (article.excerpt != null && article.excerpt!.isNotEmpty)
                        Text(
                          article.excerpt!,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.75)) ??
                              TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.75)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 14, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                          const SizedBox(width: 4),
                          Text(
                            article.formattedDate,
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)) ??
                                TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Remove button
                IconButton(
                  icon: Icon(Icons.bookmark, color: theme.colorScheme.secondary),
                  onPressed: () => controller.showRemoveConfirmation(article),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openArticle(ArticleModel article) {
    Get.toNamed(
      '/article-detail',
      arguments: article.toJson(),
    );
  }

  Widget _buildThumbnail(BuildContext context, ArticleModel article) {
    final theme = Theme.of(context);
    // Build placeholder based on article type
    Widget buildPlaceholder() {
      IconData icon;
      Color? backgroundColor;
      
      switch (article.type?.toLowerCase()) {
        case 'video':
          icon = Icons.play_circle_outline;
          backgroundColor = theme.colorScheme.surfaceVariant;
          break;
        case 'news_feed':
          icon = Icons.feed_outlined;
          backgroundColor = theme.colorScheme.primaryContainer.withOpacity(0.14);
          break;
        default:
          icon = Icons.article_outlined;
          backgroundColor = theme.colorScheme.surfaceVariant;
      }
      
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 40, color: theme.colorScheme.onSurface.withOpacity(0.7)),
      );
    }
    
    String? imageUrl;
    
    // Try to get image from coverImage or media array
    if (article.coverImage != null && article.coverImage!.isNotEmpty) {
      imageUrl = article.coverImage;
    } else if (article.media != null && article.media!.isNotEmpty) {
      imageUrl = article.media!.first;
    }
    
    // Validate imageUrl
    if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'null') {
      return buildPlaceholder();
    }
    
    // Handle base64 images - decode and display with Image.memory
    if (imageUrl.startsWith('data:image')) {
      try {
        // Extract base64 data after the comma
        final base64String = imageUrl.split(',').last;
        final Uint8List bytes = base64Decode(base64String);
        
        return Container(
          width: 80,
          height: 80,
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('⚠️ Base64 image decode failed: $error');
              return buildPlaceholder();
            },
          ),
        );
      } catch (e) {
        debugPrint('⚠️ Base64 parsing error: $e');
        return buildPlaceholder();
      }
    }
    
    // Skip video files - show placeholder with play icon
    if (imageUrl.endsWith('.mp4') || imageUrl.endsWith('.webm') || imageUrl.endsWith('.mov')) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.play_circle_fill, size: 40, color: theme.colorScheme.onSurface.withOpacity(0.75)),
      );
    }
    
    // Skip invalid or excessively long URLs
    if (imageUrl.length > 2000) {
      return buildPlaceholder();
    }
    
    // Convert relative path to full URL if needed
    if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
      imageUrl = '${AppConstants.STORAGE_BASE_URL}${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}';
    }
    
    // Use Image.network for regular URLs
    return Container(
      key: ValueKey(imageUrl),
      width: 80,
      height: 80,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('⚠️ Image load failed: $error');
          return buildPlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: theme.colorScheme.surface,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          if (frame == null) {
            return Container(
              color: theme.colorScheme.surface,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          return child;
        },
      ),
    );
  }
}
