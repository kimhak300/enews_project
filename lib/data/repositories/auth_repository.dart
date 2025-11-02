import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  // Register user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authService.registerUser(
      name: name,
      email: email,
      password: password,
    );
  }

  // Login
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final userData = _authService.validateLogin(
      email: email,
      password: password,
    );

    if (userData != null) {
      await _authService.saveCurrentUser(userData);
      return UserModel.fromLegacyMap(userData);
    }

    return null;
  }

  // Get current user
  UserModel? getCurrentUser() {
    final userData = _authService.getCurrentUser();
    if (userData != null) {
      return UserModel.fromLegacyMap(userData);
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
  }

  // Check if logged in
  bool isLoggedIn() {
    return _authService.isLoggedIn();
  }

  // Check if email exists
  bool emailExists(String email) {
    return _authService.emailExists(email);
  }

  // Update user profile
  Future<bool> updateProfile({
    required String name,
    String? phone,
    String? avatar,
  }) async {
    final currentUser = _authService.getCurrentUser();
    if (currentUser == null) return false;

    currentUser['name'] = name;
    if (phone != null) currentUser['phone'] = phone;
    if (avatar != null) currentUser['avatar'] = avatar;

    await _authService.saveCurrentUser(currentUser);
    return true;
  }
}
