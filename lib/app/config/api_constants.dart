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

  // Article Endpoints
  static const String articles = '/articles';
  static const String trending = '/articles/trending';
  static const String latest = '/articles/latest';
  static const String articlesByCategory = '/articles/category'; // + /{slug}
  static const String articleById = '/articles'; // + /{id}
  static const String articleBySlug = '/articles/slug'; // + /{slug}
  static const String incrementView = '/articles'; // + /{id}/view

  // Category Endpoints
  static const String categories = '/categories';
  static const String categoryBySlug = '/categories'; // + /{slug}

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