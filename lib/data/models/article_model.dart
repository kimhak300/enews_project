class ArticleModel {
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

  ArticleModel({
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

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
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
}
