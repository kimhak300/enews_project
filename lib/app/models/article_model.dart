class Article {
  final String id;
  final String title;
  final String content;
  final String category;
  final String author;
  final String authorImage;
  final String imageUrl;
  final DateTime publishedAt;
  final int views;
  final int readTime;
  bool isBookmarked;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.author,
    required this.authorImage,
    required this.imageUrl,
    required this.publishedAt,
    required this.views,
    required this.readTime,
    this.isBookmarked = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      author: json['author'] ?? '',
      authorImage: json['authorImage'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toString()),
      views: json['views'] ?? 0,
      readTime: json['readTime'] ?? 5,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'author': author,
      'authorImage': authorImage,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'views': views,
      'readTime': readTime,
      'isBookmarked': isBookmarked,
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
