class AppConstants {

  // ---------------- API ----------------
  static const String BASE_URL = 'http://localhost:8081/api';
  static const STORAGE_BASE_URL = "http://localhost:8081";

  // ---------------- Storage Keys ----------------
  static const String TOKEN_KEY = 'auth_token';
  static const String ROLE_KEY = 'user_role';
  static const String USER_INFO_KEY = 'user_info';

  // ---------------- Other Constants ----------------
  static const int SPLASH_DELAY = 1; // seconds

  static Map<String, String> headers(String token) {
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }
}