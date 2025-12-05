class HistoryModel {
  int? historyId;
  int userId;
  int? articleId;
  String actionType; // VIEW, COMMENT, SHARE, PROFILE_VIEW
  String actionTime;
  String? metadata; // JSON string

  HistoryModel({
    this.historyId,
    required this.userId,
    this.articleId,
    required this.actionType,
    required this.actionTime,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'history_id': historyId,
      'user_id': userId,
      'article_id': articleId,
      'action_type': actionType,
      'action_time': actionTime,
      'metadata': metadata,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) => HistoryModel(
    historyId: map['history_id'],
    userId: map['user_id'],
    articleId: map['article_id'],
    actionType: map['action_type'],
    actionTime: map['action_time'],
    metadata: map['metadata'],
  );
}