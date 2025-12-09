import 'dart:convert';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/app/services/storage_service.dart';
import 'package:newshub/data/models/auth_response_model.dart';
import 'package:newshub/data/models/user_model.dart';

class AuthResult {
  final bool success;
  final AuthResponseModel? data;
  final String? error;

  AuthResult.success(this.data)
      : success = true,
        error = null;

  AuthResult.failure(this.error)
      : success = false,
        data = null;
}

class AuthService {
  final ApiService _api = ApiService.to;
  final StorageService _storage = StorageService.to;

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.login(email, password);

    if (!response.isSuccess) {
      return AuthResult.failure(response.error ?? 'Login failed');
    }

    final auth = AuthResponseModel.fromJson(
      (response.data as Map<String, dynamic>?) ?? <String, dynamic>{});

    await _persistSession(auth);
    return AuthResult.success(auth);
  }

  Future<AuthResult> register({
    required String displayName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    final response = await _api.register(
      name: displayName,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      phone: phone,
    );

    if (!response.isSuccess) {
      return AuthResult.failure(response.error ?? 'Registration failed');
    }

    final auth = AuthResponseModel.fromJson(
        (response.data as Map<String, dynamic>?) ?? <String, dynamic>{});

    // Don't persist session - user needs to login
    return AuthResult.success(auth);
  }

  Future<void> logout() async {
    await _api.logout();
    await _clearSession();
  }

  Future<UserModel?> getSavedUser() async {
    final raw = _storage.read<String>(AppConstants.USER_INFO_KEY);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<bool> hasToken() async {
    final token = _storage.read<String>(AppConstants.TOKEN_KEY);
    return token != null && token.isNotEmpty;
  }

  Future<void> _persistSession(AuthResponseModel auth) async {
    await _storage.write(AppConstants.TOKEN_KEY, auth.token);
    await _storage.write(
      AppConstants.USER_INFO_KEY,
      jsonEncode(auth.user.toJson()),
    );
    await _storage.write(AppConstants.ROLE_KEY, _deriveRole(auth.user));
  }

  Future<void> _clearSession() async {
    await _storage.remove(AppConstants.TOKEN_KEY);
    await _storage.remove(AppConstants.USER_INFO_KEY);
    await _storage.remove(AppConstants.ROLE_KEY);
  }

  String _deriveRole(UserModel user) {
    return user.primaryRole.toLowerCase();
  }
}