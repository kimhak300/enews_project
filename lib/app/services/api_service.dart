import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:newshub/app/config/api_constants.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:newshub/app/services/storage_service.dart';

class ApiService extends GetxService {
  static ApiService get to => Get.find();

  final StorageService _storage = Get.find<StorageService>();

  // Headers
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Map<String, String> get _authHeaders {
    final token = _storage.read<String>(AppConstants.TOKEN_KEY);
    return {
      ..._headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  String get _baseUrl => ApiConstants.baseUrl;

  // ============ Generic HTTP Methods ============

  Future<ApiResponse> get(String endpoint, {bool auth = false}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: auth ? _authHeaders : _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Connection error: $e');
    }
  }

  Future<ApiResponse> post(String endpoint,
      {Map<String, dynamic>? body, bool auth = false}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: auth ? _authHeaders : _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Connection error: $e');
    }
  }

  Future<ApiResponse> put(String endpoint,
      {Map<String, dynamic>? body, bool auth = false}) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: auth ? _authHeaders : _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Connection error: $e');
    }
  }

  Future<ApiResponse> delete(String endpoint, {bool auth = false}) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: auth ? _authHeaders : _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Connection error: $e');
    }
  }

  ApiResponse _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse.success(body);
    } else if (response.statusCode == 401) {
      // Token expired or invalid - logout
      _storage.remove(AppConstants.TOKEN_KEY);
      _storage.remove(AppConstants.USER_INFO_KEY);
      return ApiResponse.error('Session expired. Please login again.', code: 401);
    } else if (response.statusCode == 403) {
      final message = body['message'] ?? 'Access denied.';
      return ApiResponse.error(message, code: 403);
    } else if (response.statusCode == 404) {
      final message = body['message'] ?? 'Resource not found.';
      return ApiResponse.error(message, code: 404);
    } else if (response.statusCode == 422) {
      // Validation errors: flatten Laravel validation response into readable text
      final errors = body['errors'] ?? body['message'] ?? 'Validation failed';
      if (errors is Map) {
        final messages = errors.values
            .whereType<List>()
            .expand((e) => e)
            .map((e) => e.toString())
            .toList();
        return ApiResponse.error(messages.join('\n'), code: 422);
      }
      return ApiResponse.error(errors.toString(), code: 422);
    } else {
      final message = body['message'] ?? 'An error occurred';
      return ApiResponse.error(message, code: response.statusCode);
    }
  }

  // ============ Auth Methods ============

  Future<ApiResponse> login(String email, String password) async {
    return post(ApiConstants.login, body: {
      'email': email,
      'password': password,
    });
  }

  Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    return post(ApiConstants.register, body: {
      'display_name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      if (phone != null) 'phone': phone,
    });
  }

  Future<ApiResponse> logout() async {
    final result = await post(ApiConstants.logout, auth: true);
    if (result.isSuccess) {
      _storage.remove(AppConstants.TOKEN_KEY);
      _storage.remove(AppConstants.USER_INFO_KEY);
    }
    return result;
  }

  Future<ApiResponse> getCurrentUser() async {
    return get(ApiConstants.me, auth: true);
  }

  // ============ User Methods ============

  Future<ApiResponse> getUsers({int page = 1, int perPage = 15, String? role, String? search}) async {
    final params = <String>[];
    params.add('page=$page');
    params.add('per_page=$perPage');
    if (role != null) params.add('role=$role');
    if (search != null && search.isNotEmpty) params.add('search=$search');
    
    final query = params.join('&');
    return get('${ApiConstants.users}?$query', auth: false);
  }

  Future<ApiResponse> getUserById(int id) async {
    return get(ApiConstants.userById(id), auth: true);
  }

  Future<ApiResponse> createUser(Map<String, dynamic> data) async {
    return post(ApiConstants.users, body: data, auth: true);
  }

  Future<ApiResponse> updateUser(int id, Map<String, dynamic> data) async {
    return put(ApiConstants.userById(id), body: data, auth: true);
  }

  Future<ApiResponse> deleteUser(int id) async {
    return delete(ApiConstants.userById(id), auth: true);
  }

  Future<ApiResponse> assignRole(int userId, int roleId) async {
    return post('/users/$userId/assign-role', body: {'role_id': roleId}, auth: true);
  }

  Future<ApiResponse> removeRole(int userId, int roleId) async {
    return delete('/users/$userId/remove-role?role_id=$roleId', auth: true);
  }

  // ============ Article Methods ============

  Future<ApiResponse> getArticles({int page = 1, int perPage = 15, String? type}) async {
    final params = <String>[];
    params.add('page=$page');
    params.add('per_page=$perPage');
    if (type != null && type.isNotEmpty) params.add('type=$type');
    
    final query = params.join('&');
    return get('${ApiConstants.articles}?$query');
  }

  Future<ApiResponse> getArticleById(int id) async {
    return get(ApiConstants.articleById(id));
  }

  Future<ApiResponse> createArticle(Map<String, dynamic> data) async {
    return post(ApiConstants.articles, body: data, auth: true);
  }

  Future<ApiResponse> updateArticle(int id, Map<String, dynamic> data) async {
    return put(ApiConstants.articleById(id), body: data, auth: true);
  }

  Future<ApiResponse> deleteArticle(int id) async {
    return delete(ApiConstants.articleById(id), auth: true);
  }

  // ============ Category Methods ============

  Future<ApiResponse> getCategories() async {
    return get(ApiConstants.categories);
  }

  Future<ApiResponse> getCategoryById(int id) async {
    return get(ApiConstants.categoryById(id));
  }

  Future<ApiResponse> createCategory(Map<String, dynamic> data) async {
    return post(ApiConstants.categories, body: data, auth: true);
  }

  Future<ApiResponse> updateCategory(int id, Map<String, dynamic> data) async {
    return put(ApiConstants.categoryById(id), body: data, auth: true);
  }

  Future<ApiResponse> deleteCategory(int id) async {
    return delete(ApiConstants.categoryById(id), auth: true);
  }

  // ============ Bookmark Methods ============

  Future<ApiResponse> getBookmarks() async {
    return get(ApiConstants.bookmarks, auth: true);
  }

  Future<ApiResponse> addBookmark(int articleId) async {
    return post(ApiConstants.bookmark, body: {'article_id': articleId}, auth: true);
  }

  Future<ApiResponse> removeBookmark(int articleId) async {
    return delete(ApiConstants.removeBookmark(articleId), auth: true);
  }

  // ============ Admin Methods ============

  Future<ApiResponse> getAdminStats() async {
    return get(ApiConstants.adminStats, auth: false); // Public for dev
  }

  Future<ApiResponse> getAdminUserStats() async {
    return get('/admin/user-stats', auth: true);
  }

  Future<ApiResponse> getAdminArticleStats() async {
    return get('/admin/article-stats', auth: true);
  }

  // ============ Organization Methods ============

  Future<ApiResponse> getOrgStats() async {
    return get(ApiConstants.orgStats, auth: true);
  }

  // ============ Role Methods ============

  Future<ApiResponse> getRoles() async {
    return get(ApiConstants.roles, auth: true);
  }

  // ============ Follow Methods ============

  Future<ApiResponse> followUser(int userId) async {
    return post(ApiConstants.userFollow(userId), auth: true);
  }

  Future<ApiResponse> unfollowUser(int userId) async {
    return delete(ApiConstants.userUnfollow(userId), auth: true);
  }

  Future<ApiResponse> getFollowers(int userId) async {
    return get(ApiConstants.userFollowers(userId), auth: true);
  }

  Future<ApiResponse> getFollowing(int userId) async {
    return get(ApiConstants.userFollowing(userId), auth: true);
  }
}

class ApiResponse {
  final bool isSuccess;
  final dynamic data;
  final String? error;
  final int? code;

  ApiResponse._({
    required this.isSuccess,
    this.data,
    this.error,
    this.code,
  });

  factory ApiResponse.success(dynamic data) {
    return ApiResponse._(isSuccess: true, data: data);
  }

  factory ApiResponse.error(String message, {int? code}) {
    return ApiResponse._(isSuccess: false, error: message, code: code);
  }
}
