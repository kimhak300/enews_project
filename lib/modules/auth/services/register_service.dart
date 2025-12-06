import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../app/constants/app_constant.dart';

class RegisterService {
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final url = Uri.parse('${AppConstants.BASE_URL}/register');

    final body = json.encode({
      "email": email,
      "password": password,
      "full_name": fullName,
      "phone": phone,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Register failed');
    }
  }
}