// lib/modules/articles/models/article_model.dart
class ArticleModel {
  final int id;
  final String slug;
  final String title;
  final String subtitle;
  final String excerpt;
  final String contentHtml;
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
      'status': status,
      'is_featured': isFeatured,
      'categories': categories,
      'tags': tags,
      'media': media,
      'author_id': authorId,
    };
  }
}