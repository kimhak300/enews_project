class Comment {
  final String id;
  final String postId;
  final String authorName;
  final String? authorImage;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.authorName,
    this.authorImage,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'postId': postId,
        'authorName': authorName,
        'authorImage': authorImage,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        postId: json['postId'],
        authorName: json['authorName'],
        authorImage: json['authorImage'],
        text: json['text'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  String getTimeAgo() {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
