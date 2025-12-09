import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/core/widgets/video_player_widget.dart';
import 'package:newshub/app/config/api_constants.dart';

class UserArticleDetailView extends StatelessWidget {
  const UserArticleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> article = Get.arguments ?? {};
    
    final String title = article['title'] ?? 'Article';
    final String? subtitle = article['subtitle'];
    final String? content = article['content'] ?? article['content_html'];
    final String? excerpt = article['excerpt'];
    final String type = article['type'] ?? 'article';
    final List<String> media = List<String>.from(article['media'] ?? []);
    final List categories = article['categories'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(type == 'video' ? 'Video' : type == 'news_feed' ? 'Hot News' : 'Article'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media Section
            if (media.isNotEmpty) ...[
              if (type == 'video')
                _buildVideoSection(media)
              else
                _buildImageSection(media),
              SizedBox(height: 16.h),
            ],
            
            // Content Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  if (categories.isNotEmpty) ...[
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: categories.map((cat) {
                        final catName = cat is String ? cat : cat['name'] ?? 'Category';
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            catName.toString().toUpperCase(),
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.h),
                  ],
                  
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  
                  // Subtitle
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                  
                  SizedBox(height: 16.h),
                  
                  // Excerpt
                  if (excerpt != null && excerpt.isNotEmpty) ...[
                    Text(
                      excerpt,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey[700],
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                  
                  // Content
                  if (content != null && content.isNotEmpty) ...[
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1.7,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                  
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoSection(List<String> media) {
    // Find video file and validate it's not null/empty
    final videoUrl = media.firstWhere(
      (m) => m.isNotEmpty && m != 'null' && _isVideo(m),
      orElse: () => '',
    );
    
    // If no valid video URL found, show placeholder
    if (videoUrl.isEmpty || videoUrl == 'null') {
      return Container(
        width: double.infinity,
        height: 250.h,
        color: Colors.grey[300],
        child: Center(
          child: Icon(Icons.error_outline, size: 48.sp, color: Colors.grey[500]),
        ),
      );
    }
    
    return Container(
      width: double.infinity,
      height: 250.h,
      color: Colors.black,
      child: VideoPlayerWidget(
        videoUrl: videoUrl,
        height: 250.h,
        width: double.infinity,
        showControls: true,
      ),
    );
  }

  Widget _buildImageSection(List<String> media) {
    // Filter out videos, null/empty values, keep only valid images
    final images = media.where((m) => 
      m.isNotEmpty && m != 'null' && !_isVideo(m)
    ).toList();
    if (images.isEmpty) return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      height: 250.h,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return _buildImage(images[index]);
        },
      ),
    );
  }

  Widget _buildImage(String imageData) {
    // Validate image data is not null or empty
    if (imageData.isEmpty || imageData == 'null') {
      return _errorPlaceholder();
    }
    
    if (imageData.startsWith('data:image')) {
      // Base64 image
      try {
        final base64String = imageData.split(',').last;
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } catch (e) {
        return _errorPlaceholder();
      }
    } else {
      // URL image - convert relative paths to full URLs
      String imageUrl = imageData;
      if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
        imageUrl = '${ApiConstants.mediaBaseUrl}${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}';
      }
      
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => _errorPlaceholder(),
      );
    }
  }

  Widget _errorPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(Icons.broken_image, size: 48.sp, color: Colors.grey[500]),
      ),
    );
  }

  bool _isVideo(String media) {
    final lower = media.toLowerCase();
    return lower.endsWith('.mp4') || lower.endsWith('.mov') || 
           lower.endsWith('.avi') || lower.endsWith('.webm') ||
           lower.contains('/video/');
  }
}
