import 'user_model.dart';

class ArticleModel {
  final int id;
  final String title;
  final String? content;
  final String? excerpt;
  final String? coverImage;
  final String? status;
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
    this.content,
    this.excerpt,
    this.coverImage,
    this.status,
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
      content: json['content'] ?? json['content_html'],
      excerpt: json['excerpt'] ?? json['subtitle'],
      coverImage: json['cover_image'] ?? json['cover_url'],
      status: json['status'],
      authorId: json['author_id'],
      author: json['author'] != null ? UserModel.fromJson(json['author']) : null,
      categories: json['categories'] != null
          ? (json['categories'] as List).map((c) => CategoryModel.fromJson(c)).toList()
          : null,
      tags: json['tags'] != null
          ? (json['tags'] as List).map((t) => TagModel.fromJson(t)).toList()
          : null,
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
      'content': content,
      'excerpt': excerpt,
      'cover_image': coverImage,
      'status': status,
      'author_id': authorId,
      'categories': categories?.map((c) => c.toJson()).toList(),
      'tags': tags?.map((t) => t.toJson()).toList(),
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
