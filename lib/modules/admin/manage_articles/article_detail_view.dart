import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/article_controller.dart';
import 'package:newshub/app/config/api_constants.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/app/services/storage_service.dart';
import 'package:newshub/core/widgets/video_player_widget.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/update_article_bottomsheet.dart';

class ArticleDetailView extends StatefulWidget {
  final Map<String, dynamic> article;

  const ArticleDetailView({super.key, required this.article});

  @override
  State<ArticleDetailView> createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<ArticleDetailView> {

  final ArticleController controller = Get.put(ArticleController());

  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final media = List<String>.from(widget.article['media'] ?? []);
    final categories = List<String>.from(widget.article['categories'] ?? []);
    final content = widget.article['content_html'] ?? '';
    final title = widget.article['title'] ?? '';
    final articleType = widget.article['type'] ?? 'article';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showUpdateBottomSheet();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.paddingS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show video player if type is video
            if (articleType == 'video' && media.isNotEmpty) _videoSection(),
            // Show images for other types
            if (articleType != 'video' && media.isNotEmpty) _image(),
            SizedBox(height: AppSpacing.paddingL),
            _title(),
            if (categories.isNotEmpty) _category(),
            if (categories.isNotEmpty) SizedBox(height: AppSpacing.paddingL),
            if (content.isNotEmpty) _content(),
            if (content.isNotEmpty) SizedBox(height: AppSpacing.paddingL),
          ],
        ),
      ),
    );
  }

  // ---------- Video Section ----------
  Widget _videoSection() {
    final media = List<String>.from(widget.article['media'] ?? []);
    if (media.isEmpty) return const SizedBox.shrink();
    
    // Find video file in media and validate it's not null/empty
    final videoUrl = media.firstWhere(
      (m) => m.isNotEmpty && m != 'null' && _isVideoMedia(m),
      orElse: () => '',
    );
    
    // If no valid video URL found, show placeholder
    if (videoUrl.isEmpty || videoUrl == 'null') {
      return _errorPlaceholder(double.infinity, 250.0);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: VideoPlayerWidget(
            videoUrl: videoUrl,
            height: 250,
            width: double.infinity,
            showControls: true,
          ),
        ),
      ],
    );
  }

  // ---------- Image Section ----------
  Widget _image() {
    final media = List<String>.from(widget.article['media'] ?? []);
    // Filter out video files, null values, and keep only valid images
    final imageMedia = media.where((m) => 
      m.isNotEmpty && m != 'null' && _isImageMedia(m)
    ).toList();
    if (imageMedia.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _buildMediaWidget(imageMedia[currentImageIndex.clamp(0, imageMedia.length - 1)], 
            width: double.infinity, height: 200),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageMedia.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentImageIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: currentImageIndex == index
                      ? const EdgeInsets.all(3)
                      : EdgeInsets.zero,
                  decoration: currentImageIndex == index
                      ? BoxDecoration(
                    border: Border.all(
                        color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  )
                      : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildMediaWidget(imageMedia[index], width: 60, height: 80),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  // ---------- Title Section ----------
  Widget _title() {
    final title = widget.article['title'] ?? '';
    final subtitle = widget.article['subtitle'] ?? '';
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }

  // ---------- Categories Section ----------
  Widget _category() {
    final categories = List<String>.from(widget.article['categories'] ?? []);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: categories
          .map(
            (cat) => Chip(
          backgroundColor: Colors.blueAccent.shade100,
          label: Text(
            cat,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent.shade700,
            ),
          ),
        ),
      )
          .toList(),
    );
  }

  // ---------- Content Section ----------
  Widget _content() {
    final content = widget.article['content_html'] ?? '';
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // ---------- Show Update BottomSheet ----------
  void _showUpdateBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => UpdateArticleBottomsheet(article: widget.article),
    ).then((_) {
      setState(() {});
    });
  }

  void _confirmDelete() {
    // Check if user is authenticated
    final storage = Get.find<StorageService>();
    final token = storage.read<String>(AppConstants.TOKEN_KEY);
    
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Authentication Required',
        'Please login first to delete articles',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Article'),
        content: const Text('Are you sure you want to delete this article?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Close dialog first using Get
              Get.back();
              
              // Validate article ID
              final articleId = widget.article['id'];
              if (articleId == null) {
                Get.snackbar(
                  'Error',
                  'Invalid article ID',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              
              print('🗑️ Attempting to delete article ID: $articleId');
              
              // Close detail screen BEFORE starting async operation
              Get.back();
              
              try {
                await controller.deleteArticle(articleId);
                
                print('✅ Article deleted successfully');
                
                // Show success message after navigation
                Get.snackbar(
                  'Success',
                  'Article deleted successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e) {
                print('❌ Delete failed: $e');
                
                // Extract user-friendly error message
                String errorMessage = 'Failed to delete article';
                final errorStr = e.toString();
                
                if (errorStr.contains('not found') || errorStr.contains('No query results')) {
                  errorMessage = 'Article not found or already deleted';
                } else if (errorStr.contains('Exception:')) {
                  // Extract message after "Exception: "
                  final parts = errorStr.split('Exception: ');
                  if (parts.length > 1) {
                    errorMessage = parts[1].trim();
                  }
                }
                
                // Show error message
                Get.snackbar(
                  'Error',
                  errorMessage,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 5),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Check if media is an image (not a video)
  bool _isImageMedia(String media) {
    final lower = media.toLowerCase();
    // Skip video files
    if (lower.endsWith('.mp4') || lower.endsWith('.mov') || 
        lower.endsWith('.avi') || lower.endsWith('.webm') ||
        lower.contains('/video/')) {
      return false;
    }
    return true;
  }

  // Check if media is a video
  bool _isVideoMedia(String media) {
    final lower = media.toLowerCase();
    return lower.endsWith('.mp4') || lower.endsWith('.mov') || 
           lower.endsWith('.avi') || lower.endsWith('.webm') ||
           lower.contains('/video/');
  }

  // Build appropriate widget for media (URL or base64)
  Widget _buildMediaWidget(String media, {double? width, double? height}) {
    // Validate media is not null or empty
    if (media.isEmpty || media == 'null') {
      return _errorPlaceholder(width, height);
    }
    
    final lower = media.toLowerCase();
    
    // Handle full HTTP URLs
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return Image.network(
        media,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _errorPlaceholder(width, height),
      );
    }
    
    // Handle file:// URIs
    if (lower.startsWith('file://')) {
      String path = media.replaceFirst(RegExp(r'^file:\/\/\/?'), '');
      // Check if path is valid (not null or empty after extraction)
      if (path.isEmpty || path == 'null') {
        return _errorPlaceholder(width, height);
      }
      if (!path.startsWith('/')) {
        path = '/$path';
      }
      final fullUrl = '${ApiConstants.mediaBaseUrl}$path';
      return Image.network(
        fullUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _errorPlaceholder(width, height),
      );
    }
    
    // Handle relative paths - convert to full URL
    if (lower.startsWith('/storage/') || lower.startsWith('storage/')) {
      final fullUrl = '${ApiConstants.mediaBaseUrl}${media.startsWith('/') ? media : '/$media'}';
      return Image.network(
        fullUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _errorPlaceholder(width, height),
      );
    }
    
    // Handle base64 data URIs
    if (media.contains(',')) {
      try {
        final bytes = base64Decode(media.split(',').last);
        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _errorPlaceholder(width, height),
        );
      } catch (_) {
        return _errorPlaceholder(width, height);
      }
    }
    
    return _errorPlaceholder(width, height);
  }

  Widget _errorPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
    );
  }
}
