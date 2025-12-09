class AppConstants {

  // ---------------- API ----------------
  // For Android Emulator: use 10.0.2.2 (maps to host localhost)
  // For iOS Simulator: use localhost
  // For Physical Device: use your computer's IP address (e.g., 192.168.x.x)
  static const String BASE_URL = 'http://10.0.2.2:8000/api';
  static const String STORAGE_BASE_URL = 'http://10.0.2.2:8000';

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