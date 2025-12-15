import 'dart:convert';
import 'dart:io';
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

    // Fetch fresh user data from server after login
    await refreshUserData();

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

  Future<void> refreshUserData() async {
    try {
      final response = await _api.getCurrentUser();
      if (response.isSuccess && response.data['user'] != null) {
        final user = UserModel.fromJson(response.data['user']);
        await _storage.write(
          AppConstants.USER_INFO_KEY,
          jsonEncode(user.toJson()),
        );
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }

  Future<bool> updateProfile({
    String? displayName,
    String? email,
    String? avatarPath,
  }) async {
    try {
      String? avatarBase64;

      // Convert image file to base64 if provided
      if (avatarPath != null && avatarPath.isNotEmpty) {
        try {
          final file = File(avatarPath);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            final extension = avatarPath.split('.').last.toLowerCase();
            String mimeType = 'image/jpeg';

            if (extension == 'png') {
              mimeType = 'image/png';
            } else if (extension == 'gif') {
              mimeType = 'image/gif';
            } else if (extension == 'webp') {
              mimeType = 'image/webp';
            } else if (extension == 'jpg' || extension == 'jpeg') {
              mimeType = 'image/jpeg';
            }

            avatarBase64 = 'data:$mimeType;base64,${base64Encode(bytes)}';
            print('Avatar converted to base64, size: ${avatarBase64.length}');
          } else {
            print('Avatar file does not exist: $avatarPath');
          }
        } catch (e) {
          print('Error converting image to base64: $e');
          // Continue without avatar if conversion fails
        }
      }

      print('Calling updateProfile API...');
      print('displayName: $displayName');
      print('email: $email');
      print('hasAvatar: ${avatarBase64 != null}');

      final response = await _api.updateProfile(
        displayName: displayName,
        email: email,
        avatarBase64: avatarBase64,
      );

      print('API Response isSuccess: ${response.isSuccess}');
      print('API Response data type: ${response.data.runtimeType}');
      print('API Response data: ${response.data}');
      print('API Response error: ${response.error}');

      if (response.isSuccess) {
        // The response.data might be the whole response object
        // Check both response.data['user'] and response.data directly
        dynamic userData;

        if (response.data is Map) {
          userData = response.data['user'] ?? response.data;
          print('userData from Map: $userData');
        } else {
          userData = response.data;
          print('userData direct: $userData');
        }

        if (userData != null && userData is Map) {
          try {
            final user = UserModel.fromJson(userData as Map<String, dynamic>);
            await _storage.write(
              AppConstants.USER_INFO_KEY,
              jsonEncode(user.toJson()),
            );
            print('Profile updated successfully!');
            return true;
          } catch (e) {
            print('Error parsing user data: $e');
            print('userData content: $userData');
            // Still refresh from server
            await refreshUserData();
            return true;
          }
        } else {
          // Even if user data is not returned, the update might have succeeded
          print(
              'Update succeeded but no/invalid user data, refreshing from server');
          // Refresh user data from server
          await refreshUserData();
          return true;
        }
      }
      print('Update failed: ${response.error}');
      return false;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
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

  /// Change password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await _api.post(
        '/change-password',
        body: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
        auth: true,
      );

      if (response.isSuccess) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Password changed successfully'
        };
      } else {
        return {
          'success': false,
          'message': response.error ?? 'Failed to change password'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e'
      };
    }
  }

  /// Delete account
  Future<Map<String, dynamic>> deleteAccount({
    required String password,
  }) async {
    try {
      final response = await _api.post(
        '/delete-account',
        body: {
          'password': password,
        },
        auth: true,
      );

      if (response.isSuccess) {
        // Clear local session
        await _clearSession();
        
        return {
          'success': true,
          'message': response.data['message'] ?? 'Account deleted successfully'
        };
      } else {
        return {
          'success': false,
          'message': response.error ?? 'Failed to delete account'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: $e'
      };
    }
  }
}
