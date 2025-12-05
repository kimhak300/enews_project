class CommentModel {
  int? commentId;
  int articleId;
  int userId;
  String content;
  String createdAt;

  CommentModel({
    this.commentId,
    required this.articleId,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'comment_id': commentId,
      'article_id': articleId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) => CommentModel(
    commentId: map['comment_id'],
    articleId: map['article_id'],
    userId: map['user_id'],
    content: map['content'],
    createdAt: map['created_at'],
  );
}