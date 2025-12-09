// lib/modules/articles/models/article_model.dart
import 'package:newshub/app/config/app_config.dart';

class ArticleModel {
  final int id;
  final String slug;
  final String title;
  final String subtitle;
  final String excerpt;
  final String contentHtml;
  final String type; // article, video, news_feed
  final int authorId;
  final String status;
  final bool isFeatured;
  final String languageCode;
  final List<String> categories;
  final List<String> tags;
  final List<String> media;
  final DateTime createdAt;
  final DateTime updatedAt;

  ArticleModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.subtitle,
    required this.excerpt,
    required this.contentHtml,
    required this.type,
    required this.authorId,
    required this.status,
    required this.isFeatured,
    required this.languageCode,
    this.categories = const [],
    this.tags = const [],
    this.media = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      excerpt: json['excerpt'] ?? '',
      contentHtml: json['content_html'] ?? '',
      type: json['type'] ?? 'article',
      authorId: json['author_id'] ?? 0,
      status: json['status'] ?? 'draft',
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
      languageCode: json['language_code'] ?? 'en',
      categories: (json['categories'] as List<dynamic>?)
          ?.map((c) => c.toString())
          .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
          ?.map((t) => t.toString())
          .toList() ??
          [],
      media: (json['media'] as List<dynamic>?)
          ?.map((m) => m.toString())
          .where((m) => m.isNotEmpty && m != 'null')
          .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'excerpt': excerpt,
      'content_html': contentHtml,
      'type': type,
      'status': status,
      'is_featured': isFeatured,
      'categories': categories,
      'tags': tags,
      'media': media,
      'author_id': authorId,
    };
  }
}
// Helper function to normalize URLs
String? _normalizeUrl(String? url) {
  if (url == null || url.isEmpty || url == 'null') return null;
  
  // Already a full URL (http/https)
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url;
  }
  
  // Base64 encoded image
  if (url.startsWith('data:image')) {
    return url;
  }
  
  // Relative path - convert to full URL
  final cleanPath = url.replaceFirst(RegExp(r'^file:///'), '');
  if (cleanPath.isEmpty || cleanPath == 'null') return null;
  
  return AppConfig.getImageUrl(cleanPath);
}
