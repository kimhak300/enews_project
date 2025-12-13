import 'user_model.dart';

class ArticleModel {
  final int id;
  final String title;
  final String? subtitle;
  final String? content;
  final String? excerpt;
  final String? coverImage;
  final List<String>? media;
  final String? type; // article, video, news_feed
  final String? status;
  final bool? isFeatured;
  final int? authorId;
  final UserModel? author;
  final List<CategoryModel>? categories;
  final List<TagModel>? tags;
  final int? viewCount;
  final int? likeCount;
  final int? commentCount;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ArticleModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.content,
    this.excerpt,
    this.coverImage,
    this.media,
    this.type,
    this.status,
    this.isFeatured,
    this.authorId,
    this.author,
    this.categories,
    this.tags,
    this.viewCount,
    this.likeCount,
    this.commentCount,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      content: json['content'] ?? json['content_html'],
      excerpt: json['excerpt'],
      coverImage: json['cover_image'] ?? json['cover_url'],
      media: (json['media'] as List?)?.map((m) => m.toString()).toList(),
      type: json['type'] ?? 'article',
      status: json['status'],
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
      authorId: json['author_id'],
      author:
          json['author'] != null ? UserModel.fromJson(json['author']) : null,
      categories: _parseCategories(json['categories']),
      tags: _parseTags(json['tags']),
      viewCount: json['view_count'],
      likeCount: json['like_count'],
      commentCount: json['comment_count'],
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'excerpt': excerpt,
      'cover_image': coverImage,
      'media': media,
      'type': type,
      'status': status,
      'is_featured': isFeatured,
      'author_id': authorId,
      'author': author?.toJson(),
      'categories': categories?.map((c) => c.toJson()).toList(),
      'tags': tags?.map((t) => t.toJson()).toList(),
      'view_count': viewCount,
      'like_count': likeCount,
      'comment_count': commentCount,
      'published_at': publishedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Check if article is published
  bool get isPublished => status == 'published';

  /// Check if article is draft
  bool get isDraft => status == 'draft';

  /// Get formatted date
  String get formattedDate {
    final date = publishedAt ?? createdAt;
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Estimated read time in minutes (computed from content/excerpt)
  /// This ensures older callers using `article.readTime` won't throw.
  int get readTime {
    final text = (content ?? excerpt ?? '').trim();
    if (text.isEmpty) return 1;
    final words = RegExp(r"\w+").allMatches(text).length;
    final minutes = (words / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }
}

// -------- Helpers to tolerate string-or-map payloads --------
List<CategoryModel>? _parseCategories(dynamic raw) {
  if (raw == null) return null;
  if (raw is List) {
    return raw.map<CategoryModel>((c) {
      if (c is Map<String, dynamic>) return CategoryModel.fromJson(c);
      final name = c?.toString() ?? '';
      return CategoryModel(id: 0, name: name);
    }).toList();
  }
  return null;
}

List<TagModel>? _parseTags(dynamic raw) {
  if (raw == null) return null;
  if (raw is List) {
    return raw.map<TagModel>((t) {
      if (t is Map<String, dynamic>) return TagModel.fromJson(t);
      final name = t?.toString() ?? '';
      return TagModel(id: 0, name: name);
    }).toList();
  }
  return null;
}

class CategoryModel {
  final int id;
  final String name;
  final String? slug;
  final String? description;
  final String? imageUrl;
  final int? articleCount;

  CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.imageUrl,
    this.articleCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'],
      description: json['description'],
      imageUrl: json['image_url'],
      articleCount: json['articles_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'image_url': imageUrl,
    };
  }
}

class TagModel {
  final int id;
  final String name;
  final String? slug;
  final int? articleCount;

  TagModel({
    required this.id,
    required this.name,
    this.slug,
    this.articleCount,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'],
      articleCount: json['articles_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}
