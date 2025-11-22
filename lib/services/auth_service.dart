import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  final Dio _dio = ApiService.instance.client;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final resp = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    final data = resp.data as Map<String, dynamic>;
    final token = data['token'] as String?;
    if (token != null) {
      await ApiService.instance.saveToken(token);
    }
    return data;
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirmation) async {
    final resp = await _dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    final data = resp.data as Map<String, dynamic>;
    final token = data['token'] as String?;
    if (token != null) {
      await ApiService.instance.saveToken(token);
    }
    return data;
  }

  Future<Map<String, dynamic>> me() async {
    final resp = await _dio.get('/auth/me');
    return resp.data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } finally {
      await ApiService.instance.deleteToken();
    }
  }

  Future<Map<String, dynamic>> uploadAvatar(String filePath) async {
    final form = FormData();
    form.files.add(MapEntry('avatar', await MultipartFile.fromFile(filePath)));
    final resp = await _dio.post('/auth/avatar', data: form);
    return resp.data as Map<String, dynamic>;
  }
}
