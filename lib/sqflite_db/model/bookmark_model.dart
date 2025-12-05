class BookmarkModel {
  int? bookmarkId;
  int userId;
  int articleId;
  String createdAt;

  BookmarkModel({
    this.bookmarkId,
    required this.userId,
    required this.articleId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookmark_id': bookmarkId,
      'user_id': userId,
      'article_id': articleId,
      'created_at': createdAt,
    };
  }

  factory BookmarkModel.fromMap(Map<String, dynamic> map) => BookmarkModel(
    bookmarkId: map['bookmark_id'],
    userId: map['user_id'],
    articleId: map['article_id'],
    createdAt: map['created_at'],
  );
}