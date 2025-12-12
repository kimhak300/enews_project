import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newshub/app/config/app_config.dart';
import 'package:newshub/modules/admin/manage_articles/article_detail_view.dart';
import 'package:newshub/modules/organization/org_manage_article/org_small_video_player.dart';

class OrgArticleWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> categories;
  final List<String>? images;
  final Map<String, dynamic> articleData;

  const OrgArticleWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.categories,
    required this.articleData,
    this.images,
  });

  String _getInitials(String text) {
    final parts = text.trim().split(" ");
    if (parts.length == 1) {
      return text.substring(0, 2).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? firstImage =
        (images != null && images!.isNotEmpty) ? images!.first : null;

    // Check for video URL in media or images
    final String? videoUrl = _findVideoUrl();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailView(article: articleData),
          ),
        );
      },
      child: Card(
        color: theme.colorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Leading image / video
                  if (videoUrl != null)
                    OrgSmallVideoPlayer(url: videoUrl)
                  else
                    _buildImage(context, firstImage),
                  const SizedBox(width: 12),
                  // Title & subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: categories
                              .map((c) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(c, style: theme.textTheme.bodySmall),
                                  ))
                              .toList(),
                        ),
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

  //---------------------------------------------------------
  // Image builder that supports network URLs and base64 data URIs
  //---------------------------------------------------------
  Widget _buildImage(BuildContext context, String? image) {
    if (image == null || image.isEmpty) {
      return _fallbackAvatar(context);
    }

    // Skip video files - they can't be displayed as images
    final lowerImage = image.toLowerCase();
    if (lowerImage.endsWith('.mp4') || lowerImage.endsWith('.mov') ||
        lowerImage.endsWith('.avi') || lowerImage.endsWith('.webm')) {
      return _fallbackVideoAvatar(context);
    }

    // Base64 data URI (e.g., data:image/png;base64,...)
    if (_isBase64DataUri(image)) {
      try {
        final bytes = base64Decode(image.split(',').last);
        return Image.memory(
          bytes,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackAvatar(context),
        );
      } catch (_) {
        return _fallbackAvatar(context);
      }
    }

    // Assume URL
    return Image.network(
      image,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackAvatar(context),
    );
  }

  bool _isBase64DataUri(String value) {
    return value.startsWith('data:image');
  }

  /// Find video URL from article media or images
  String? _findVideoUrl() {
    // First check if firstImage is a video
    if (images != null && images!.isNotEmpty) {
      final firstImage = images!.first;
      if (_isVideoUrl(firstImage)) {
        return _constructFullUrl(firstImage);
      }
    }

    // Then check media field from articleData
    try {
      final media = articleData['media'];
      if (media is List && media.isNotEmpty) {
        for (final item in media) {
          final url = item?.toString() ?? '';
          if (_isVideoUrl(url)) {
            return _constructFullUrl(url);
          }
        }
      }
    } catch (_) {}

    return null;
  }

  /// Construct full URL from relative or absolute path
  String _constructFullUrl(String url) {
    // If already a full URL, return as is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    // For relative paths, use AppConfig to construct full URL
    return AppConfig.getImageUrl(url);
  }

  /// Check if URL is a video file
  bool _isVideoUrl(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.webm');
  }

  //---------------------------------------------------------
  // Fallback Video Avatar
  //---------------------------------------------------------
  Widget _fallbackVideoAvatar(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.video_library,
          size: 30,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  //---------------------------------------------------------
  // Fallback Avatar (if no image)
  //---------------------------------------------------------
  Widget _fallbackAvatar(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          _getInitials(title),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
