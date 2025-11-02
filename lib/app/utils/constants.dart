class Constants {


  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String bookmarksKey = 'bookmarks';
  static const String usersKey = 'registered_users';
  static const String currentUserKey = 'current_user';

  // Pagination
  static const int pageSize = 20;

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 1);

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
