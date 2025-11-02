import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newshub/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';

class AuthService {
  final _storage = GetStorage();

  // Storage keys
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';

  // ===========================
  // 🔹 Local User Management
  // ===========================

  List<Map<String, dynamic>> getRegisteredUsers() {
    final users = _storage.read(_usersKey);
    if (users == null) return [];
    return List<Map<String, dynamic>>.from(users);
  }

  bool emailExists(String email) {
    final users = getRegisteredUsers();
    return users.any(
      (user) => user['email'].toString().toLowerCase() == email.toLowerCase(),
    );
  }

  bool registerUser({
    required String name,
    required String email,
    required String password,
  }) {
    if (emailExists(email)) return false;

    final users = getRegisteredUsers();
    users.add({
      'name': name,
      'email': email.toLowerCase(),
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
    });

    _storage.write(_usersKey, users);
    return true;
  }

  Map<String, dynamic>? validateLogin({
    required String email,
    required String password,
  }) {
    final users = getRegisteredUsers();
    try {
      final user = users.firstWhere(
        (user) =>
            user['email'].toString().toLowerCase() == email.toLowerCase() &&
            user['password'] == password,
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  void saveCurrentUser(Map<String, dynamic> user) {
    _storage.write(_currentUserKey, user);
  }

  Map<String, dynamic>? getCurrentUser() {
    return _storage.read(_currentUserKey);
  }

  void logout() {
    _storage.remove(_currentUserKey);
  }

  bool isLoggedIn() {
    return getCurrentUser() != null;
  }

  // ===========================
  // 🔹 API Authentication (DummyJSON)
  // ===========================

  /// Login API call (https://dummyjson.com/auth/login)
  Future<Map<String, dynamic>> login(String emilys, String emilyspass) async {
    final url = Uri.parse('${AppConstants.dummyURL}auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': emilys,
        'password': emilyspass,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Store access token
      await saveToken(data['token']);

      // Optionally, save user data
      saveCurrentUser({
        'id': data['id'],
        'username': data['username'],
        'email': data['email'] ?? '',
        'image': data['image'] ?? '',
      });

      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // ===========================
  // 🔹 Get Current User Profile
  // ===========================

  /// Get current user info using saved access token
  Future<Map<String, dynamic>> getUserProfile() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found. Please log in first.');
    }

    final url = Uri.parse('${AppConstants.dummyURL}auth/me');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Optionally update local current user data
      saveCurrentUser({
        'id': data['id'],
        'username': data['username'],
        'email': data['email'] ?? '',
        'image': data['image'] ?? '',
      });

      return data;
    } else {
      throw Exception('Failed to fetch user: ${response.body}');
    }
  }

  // ===========================
  // 🔹 refreshToken
  // ===========================

  Future<String> refreshToken(
      {String? refreshToken, int expiresInMins = 30}) async {
    final url = Uri.parse('${AppConstants.dummyURL}auth/refresh');

    final body = <String, dynamic>{
      'expiresInMins': expiresInMins,
    };

    if (refreshToken != null) {
      body['refreshToken'] = refreshToken;
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newToken = data['token'] ?? data['accessToken'];

      if (newToken != null) {
        // Save new access token
        await saveToken(newToken);
        return newToken;
      } else {
        throw Exception(
            'Refresh token response did not include new access token');
      }
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  // ===========================
  // 🔹 Token Management
  // ===========================

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
  }
}
