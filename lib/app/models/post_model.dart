import 'comment_model.dart';

class Post {
  final String id;
  final String title;
  final String? coverImage;
  final String topic;
  final DateTime createdAt;
  final String authorId;
  final String authorName;
  final String? authorImage;
  int likeCount;
  int commentCount;
  int shareCount;
  bool isLiked;
  List<Comment> comments;

  Post({
    required this.id,
    required this.title,
    this.coverImage,
    required this.topic,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.isLiked = false,
    List<Comment>? comments,
  }) : comments = comments ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'coverImage': coverImage,
        'topic': topic,
        'createdAt': createdAt.toIso8601String(),
        'authorId': authorId,
        'authorName': authorName,
        'authorImage': authorImage,
        'likeCount': likeCount,
        'commentCount': commentCount,
        'shareCount': shareCount,
        'isLiked': isLiked,
        'comments': comments.map((c) => c.toJson()).toList(),
      };

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        title: json['title'],
        coverImage: json['coverImage'],
        topic: json['topic'],
        createdAt: DateTime.parse(json['createdAt']),
        authorId: json['authorId'],
        authorName: json['authorName'],
        authorImage: json['authorImage'],
        likeCount: json['likeCount'] ?? 0,
        commentCount: json['commentCount'] ?? 0,
        shareCount: json['shareCount'] ?? 0,
        isLiked: json['isLiked'] ?? false,
        comments: json['comments'] != null
            ? (json['comments'] as List)
                .map((c) => Comment.fromJson(c))
                .toList()
            : [],
      );
}
