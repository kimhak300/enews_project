import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:newshub/api/model/user_model.dart';

import '../../app/constants/app_constant.dart';

class UserService {
  final box = GetStorage();
  String get token => box.read(AppConstants.TOKEN_KEY) ?? "";

  Future<List<UserModel>> getUsers() async {
    final url = Uri.parse("${AppConstants.BASE_URL}/users");

    final response = await http.get(url, headers: AppConstants.headers(token));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      // Laravel returns "data" key, not "users"
      List data = json["data"] ?? json["users"] ?? [];

      return data.map((u) => UserModel.fromJson(u)).toList();
    }

    throw Exception("Failed to load users");
  }

  Future<void> createUser({
    required String displayName,
    required String email,
    required String password,
    required String role,
    required bool isActive,
    String? avatarBase64,
  }) async {
    final url = Uri.parse("${AppConstants.BASE_URL}/users");

    final body = {
      "display_name": displayName,
      "email": email,
      "password": password,
      "role": role,
      "is_active": isActive,
      if (avatarBase64 != null) "avatar_base64": avatarBase64,
    };

    try {
      final response = await http.post(
        url,
        headers: AppConstants.headers(token),
        body: jsonEncode(body),
      );

      if (response.statusCode != 201) {
        // Parse error message from API if available
        String errorMessage = "Failed to create user";
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          } else if (errorJson['errors'] != null) {
            errorMessage = errorJson['errors'].toString();
          }
        } catch (e) {
          errorMessage = "Failed to create user: ${response.body}";
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print("Error creating user: $e");
      rethrow;
    }
  }

  Future<void> updateUser({
    required int id,
    required String displayName,
    required String email,
    required String role,
    required bool isActive,
    String? avatarBase64,
  }) async {
    final url = Uri.parse("${AppConstants.BASE_URL}/users/$id");

    final body = {
      "display_name": displayName,
      "email": email,
      "role": role,
      "is_active": isActive,
      if (avatarBase64 != null) "avatar_base64": avatarBase64,
    };

    try {
      final response = await http.put(
        url,
        headers: AppConstants.headers(token),
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        // Parse error message from API if available
        String errorMessage = "Failed to update user";
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          } else if (errorJson['errors'] != null) {
            errorMessage = errorJson['errors'].toString();
          }
        } catch (e) {
          errorMessage = "Failed to update user: ${response.body}";
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print("Error updating user: $e");
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    final url = Uri.parse("${AppConstants.BASE_URL}/users/$id");

    final response = await http.delete(url, headers: AppConstants.headers(token));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete user");
    }
  }
}