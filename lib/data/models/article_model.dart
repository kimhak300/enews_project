// class ArticleModel {
//   final String id;
//   final String title;
//   final String content;
//   final String category;
//   final String author;
//   final String authorImage;
//   final String imageUrl;
//   final DateTime publishedAt;
//   final int views;
//   final int readTime;
//   bool isBookmarked;

//   ArticleModel({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.category,
//     required this.author,
//     required this.authorImage,
//     required this.imageUrl,
//     required this.publishedAt,
//     required this.views,
//     required this.readTime,
//     this.isBookmarked = false,
//   });

//   factory ArticleModel.fromJson(Map<String, dynamic> json) {
//     return ArticleModel(
//       id: json['id'] ?? '',
//       title: json['title'] ?? '',
//       content: json['content'] ?? '',
//       category: json['category'] ?? '',
//       author: json['author'] ?? '',
//       authorImage: json['authorImage'] ?? '',
//       imageUrl: json['imageUrl'] ?? '',
//       publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toString()),
//       views: json['views'] ?? 0,
//       readTime: json['readTime'] ?? 5,
//       isBookmarked: json['isBookmarked'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'content': content,
//       'category': category,
//       'author': author,
//       'authorImage': authorImage,
//       'imageUrl': imageUrl,
//       'publishedAt': publishedAt.toIso8601String(),
//       'views': views,
//       'readTime': readTime,
//       'isBookmarked': isBookmarked,
//     };
//   }
// }

class ArticleModel {
  final int id;
  final String title;
  final String slug;
  final String content;
  final String? excerpt;
  final int categoryId;
  final String? categoryName;
  final int authorId;
  final String? authorName;
  final String? imageUrl;
  final DateTime publishedAt;
  final int views;
  final int readTime;
  final String status;
  bool isBookmarked;

  ArticleModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    this.excerpt,
    required this.categoryId,
    this.categoryName,
    required this.authorId,
    this.authorName,
    this.imageUrl,
    required this.publishedAt,
    required this.views,
    required this.readTime,
    required this.status,
    this.isBookmarked = false,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      content: json['content'] ?? '',
      excerpt: json['excerpt'],
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category']?['name'],
      authorId: json['author_id'] ?? 0,
      authorName: json['author']?['name'],
      imageUrl: json['image_url'],
      publishedAt: DateTime.parse(
        json['published_at'] ?? DateTime.now().toIso8601String(),
      ),
      views: json['views'] ?? 0,
      readTime: json['read_time'] ?? 5,
      status: json['status'] ?? 'published',
      isBookmarked: json['is_bookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'content': content,
      'excerpt': excerpt,
      'category_id': categoryId,
      'author_id': authorId,
      'image_url': imageUrl,
      'published_at': publishedAt.toIso8601String(),
      'views': views,
      'read_time': readTime,
      'status': status,
      'is_bookmarked': isBookmarked,
    };
  }

  String getTimeAgo() {
    final difference = DateTime.now().difference(publishedAt);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String getViewsFormatted() {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }
}
