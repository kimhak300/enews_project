class LikeModel {
  int? likeId;
  int userId;
  int articleId;
  String createdAt;

  LikeModel({
    this.likeId,
    required this.userId,
    required this.articleId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'like_id': likeId,
      'user_id': userId,
      'article_id': articleId,
      'created_at': createdAt,
    };
  }

  factory LikeModel.fromMap(Map<String, dynamic> map) {
    return LikeModel(
      likeId: map['like_id'],
      userId: map['user_id'],
      articleId: map['article_id'],
      createdAt: map['created_at'],
    );
  }
}