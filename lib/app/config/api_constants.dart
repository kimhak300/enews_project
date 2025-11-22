class ApiConstants {
  // Base URL - Change according to your setup
  // For Android Emulator
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // For iOS Simulator
  // static const String baseUrl = 'http://localhost:8000/api';
  
  // For Physical Device (replace with your IP)
  // static const String baseUrl = 'http://192.168.1.100:8000/api';
  
  // For Production
  // static const String baseUrl = 'https://your-domain.com/api';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String updateProfile = '/auth/profile';
  static const String uploadAvatar = '/auth/avatar';

  // Feed Endpoints
  static const String feedPosts = '/feed/posts';
  static const String feedTrending = '/feed/posts/trending';
  static const String feedLatest = '/feed/posts/latest';
  static const String feedPostBySlug = '/feed/posts/slug'; // + /{slug}
  static const String feedPostById = '/feed/posts'; // + /{id}
  static const String feedPostView = '/feed/posts'; // + /{id}/view
  static const String feedTopics = '/feed/topics';

  // Bookmark Endpoints
  static const String bookmarks = '/bookmarks';
  static const String toggleBookmark = '/bookmarks'; // + /{id}/toggle

  // Notification Endpoints
  static const String notifications = '/notifications';
  static const String unreadCount = '/notifications/unread';
  static const String markAsRead = '/notifications'; // + /{id}/read
  static const String markAllAsRead = '/notifications/read-all';

  // Search
  static const String search = '/search';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}