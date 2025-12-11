class DashboardStatsModel {
  final int totalUsers;
  final int totalArticles;
  final int totalCategories;
  final int totalTags;
  final int totalComments;
  final int totalReactions;
  final int publishedArticles;
  final int draftArticles;
  final int activeUsers;
  final List<RecentArticle>? recentArticles;
  final List<RecentUser>? recentUsers;

  DashboardStatsModel({
    required this.totalUsers,
    required this.totalArticles,
    required this.totalCategories,
    required this.totalTags,
    required this.totalComments,
    required this.totalReactions,
    required this.publishedArticles,
    required this.draftArticles,
    required this.activeUsers,
    this.recentArticles,
    this.recentUsers,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalUsers: json['total_users'] ?? 0,
      totalArticles: json['total_articles'] ?? 0,
      totalCategories: json['total_categories'] ?? 0,
      totalTags: json['total_tags'] ?? 0,
      totalComments: json['total_comments'] ?? 0,
      totalReactions: json['total_reactions'] ?? 0,
      publishedArticles: json['published_articles'] ?? 0,
      draftArticles: json['draft_articles'] ?? 0,
      activeUsers: json['active_users'] ?? 0,
      recentArticles: json['recent_articles'] != null
          ? (json['recent_articles'] as List)
              .map((a) => RecentArticle.fromJson(a))
              .toList()
          : null,
      recentUsers: json['recent_users'] != null
          ? (json['recent_users'] as List)
              .map((u) => RecentUser.fromJson(u))
              .toList()
          : null,
    );
  }
}

class RecentArticle {
  final int id;
  final String title;
  final String? status;
  final String? authorName;
  final String? coverImage;
  final DateTime? createdAt;
  final DateTime? publishedAt;

  RecentArticle({
    required this.id,
    required this.title,
    this.status,
    this.authorName,
    this.coverImage,
    this.createdAt,
    this.publishedAt,
  });

  factory RecentArticle.fromJson(Map<String, dynamic> json) {
    // Extract cover image from media array
    String? cover;
    if (json['media'] != null && json['media'] is List && (json['media'] as List).isNotEmpty) {
      final media = json['media'][0];
      if (media is String) {
        cover = media;
      } else if (media is Map) {
        cover = media['url'] ?? media['base64'];
      }
    }

    return RecentArticle(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      status: json['status'],
      authorName: json['author_name'] ?? json['author']?['display_name'],
      coverImage: cover,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'])
          : null,
    );
  }
}

class RecentUser {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? role;
  final DateTime? createdAt;

  RecentUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.role,
    this.createdAt,
  });

  factory RecentUser.fromJson(Map<String, dynamic> json) {
    return RecentUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      role: json['role'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
