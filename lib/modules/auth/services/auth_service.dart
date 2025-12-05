import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../app/constants/app_constant.dart';

class AuthService {
  final GetStorage _storage = GetStorage();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(AppConstants.BASE_URL+'/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Login failed: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<bool> logout() async {
    final token = _storage.read(AppConstants.TOKEN_KEY);

    if (token == null || token.isEmpty) {
      throw Exception("User token not found");
    }

    final url = Uri.parse('${AppConstants.BASE_URL}/logout');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await _storage.remove(AppConstants.TOKEN_KEY);
      await _storage.remove(AppConstants.ROLE_KEY);
      return true;
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Logout failed');
    }
  }
}