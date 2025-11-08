import '../models/user_model.dart';
import '../models/auth_response_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  // Register user
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await _authService.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  // Login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    return await _authService.login(
      email: email,
      password: password,
    );
  }

  // Get current user
  Future<UserModel> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }

  // Get saved user (offline)
  Future<UserModel?> getSavedUser() async {
    return await _authService.getSavedUser();
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  // Update user profile
  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    return await _authService.updateProfile(
      name: name,
      email: email,
      phone: phone,
    );
  }
}
