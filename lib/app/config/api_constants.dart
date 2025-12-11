class ApiConstants {
  // For Android Emulator
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String mediaBaseUrl = 'http://10.0.2.2:8000';

  // ============ Auth Endpoints ============
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String me = '/me';

  // ============ User Endpoints ============
  static const String users = '/users';
  static String userById(int id) => '/users/$id';
  static String userFollow(int userId) => '/users/$userId/follow';
  static String userUnfollow(int userId) => '/users/$userId/unfollow';
  static String userFollowers(int userId) => '/users/$userId/followers';
  static String userFollowing(int userId) => '/users/$userId/following';

  // ============ Article Endpoints ============
  static const String articles = '/articles';
  static String articleById(int id) => '/articles/$id';
  static String articleCategories(int articleId) => '/articles/$articleId/categories';
  static String articleTags(int articleId) => '/articles/$articleId/tags';

  // ============ Category Endpoints ============
  static const String categories = '/categories';
  static String categoryById(int id) => '/categories/$id';

  // ============ Tag Endpoints ============
  static const String tags = '/tags';
  static String tagById(int id) => '/tags/$id';

  // ============ Role Endpoints ============
  static const String roles = '/roles';
  static String roleById(int id) => '/roles/$id';
  static String userRoles(int userId) => '/users/$userId/roles';

  // ============ Comment Endpoints ============
  static const String comments = '/comments';
  static String commentsByArticle(int articleId) => '/comments/$articleId';

  // ============ Reaction Endpoints ============
  static const String reactions = '/reactions';

  // ============ Bookmark Endpoints ============
  static const String bookmark = '/bookmark';
  static const String bookmarks = '/bookmarks';
  static String removeBookmark(int articleId) => '/bookmark/$articleId';

  // ============ Media Endpoints ============
  static const String media = '/media';
  static String mediaByArticle(int articleId) => '/media/$articleId';
  static String mediaById(int mediaId) => '/media/$mediaId';

  // ============ Admin Endpoints ============
  static const String adminStats = '/admin/stats';
  static const String adminRecentArticles = '/admin/recent-articles';
  static const String adminRecentUsers = '/admin/recent-users';

  // ============ Address Endpoints ============
  static const String addresses = '/addresses';
  static String addressById(int id) => '/addresses/$id';

  // ============ Notification Endpoints ============
  static const String notifications = '/notifications';
  static const String unreadCount = '/notifications/unread-count';
  static const String markAsRead = '/notifications';
  static const String markAllAsRead = '/notifications/mark-all-read';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}