class ArticleModel {
  int? articleId;
  String title;
  String content;
  String? imageUrl;
  int categoryId;
  int authorId;
  String? authorName;   // <--- ADD THIS
  String publishedAt;
  String createdAt;
  String updatedAt;

  ArticleModel({
    this.articleId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.categoryId,
    required this.authorId,
    this.authorName,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ArticleModel.fromMap(Map<String, dynamic> map) => ArticleModel(
    articleId: map['article_id'],
    title: map['title'],
    content: map['content'],
    imageUrl: map['image_url'],
    categoryId: map['category_id'],
    authorId: map['author_id'],
    authorName: map['author_name'],  // <--- READ FROM JOIN
    publishedAt: map['published_at'],
    createdAt: map['created_at'],
    updatedAt: map['updated_at'],
  );

  Map<String, dynamic> toMap() {
    return {
      'article_id': articleId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'category_id': categoryId,
      'author_id': authorId,
      'published_at': publishedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}