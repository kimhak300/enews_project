import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:newshub/api/model/article_model.dart';

import '../../app/constants/app_constant.dart';

class ArticleService {
  final String baseUrl = AppConstants.BASE_URL;
  final GetStorage storage = GetStorage();

  // Get all articles
  Future<List<ArticleModel>> getArticles({String? category}) async {
    String url = '$baseUrl/articles';
    if (category != null && category.isNotEmpty) {
      url += '?category=$category';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => ArticleModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  // Get single article
  Future<ArticleModel> getArticle(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/articles/$id'));
    if (response.statusCode == 200) {
      return ArticleModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get article');
    }
  }

  // Create article with token
  Future<void> createArticle(Map<String, dynamic> body) async {
    final token = storage.read(AppConstants.TOKEN_KEY);
    if (token == null) throw Exception('No token found');

    print('Creating article with token: ${token?.substring(0, 20)}...');
    print('Article data: ${jsonEncode(body)}');

    final response = await http.post(
      Uri.parse('$baseUrl/articles'),
      headers: AppConstants.headers(token),
      body: jsonEncode(body),
    );

    print('Create article response status: ${response.statusCode}');
    print('Create article response body: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception('Failed to create article: ${response.body}');
    }
  }

  // Upload media (multipart). Returns URL string.
  Future<String> uploadMedia({required File file, required String type}) async {
    print('🎬 Starting media upload...');
    print('  File path: ${file.path}');
    print('  File exists: ${await file.exists()}');
    print('  Type: $type');
    
    final token = storage.read(AppConstants.TOKEN_KEY);
    if (token == null) {
      print('❌ No token found');
      throw Exception('No token found');
    }

    final uri = Uri.parse('$baseUrl/media');
    print('  Upload URI: $uri');
    
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      })
      ..fields['type'] = type
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    print('  Sending request...');
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    print('  Response status: ${response.statusCode}');
    print('  Response body: ${response.body}');

    if (response.statusCode != 201) {
      print('❌ Upload failed with status ${response.statusCode}');
      throw Exception('Failed to upload media: ${response.body}');
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    final mediaData = responseData['data'] as Map<String, dynamic>?;
    
    if (mediaData == null) {
      print('❌ No data in response');
      throw Exception('Video upload returned no data');
    }
    
    final url = mediaData['url'] ?? mediaData['full_url'] ?? '';
    
    if (url.isEmpty) {
      print('❌ Empty URL in response. Full data: $mediaData');
      throw Exception('Video upload returned empty URL');
    }
    
    print('✅ Upload successful, URL: $url');
    return url;
  }

  // Update article with token
  Future<void> updateArticle(int id, Map<String, dynamic> body) async {
    final token = storage.read(AppConstants.TOKEN_KEY);
    if (token == null) throw Exception('No token found');

    final response = await http.put(
      Uri.parse('$baseUrl/articles/$id'),
      headers: AppConstants.headers(token),
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      final errorMsg = _parseErrorMessage(response);
      throw Exception(errorMsg);
    }
  }

  // Delete article with token
  Future<void> deleteArticle(int id) async {
    final token = storage.read(AppConstants.TOKEN_KEY);
    if (token == null) throw Exception('No token found');

    final response = await http.delete(
      Uri.parse('$baseUrl/articles/$id'),
      headers: AppConstants.headers(token),
    );

    if (response.statusCode != 200) {
      final errorMsg = _parseErrorMessage(response);
      throw Exception(errorMsg);
    }
  }

  // Helper method to parse error messages from Laravel responses
  String _parseErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      
      // Check for Laravel error message
      if (data is Map<String, dynamic>) {
        if (response.statusCode == 404) {
          return 'Article not found or already deleted';
        }
        if (data.containsKey('message')) {
          return data['message'];
        }
        if (data.containsKey('error')) {
          return data['error'];
        }
      }
      return 'Failed to complete request: ${response.statusCode}';
    } catch (e) {
      return 'Failed to complete request: ${response.body}';
    }
  }

  // Get articles by category (public)
  Future<List<ArticleModel>> getArticlesByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/articles/category/$category'));
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => ArticleModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles by category');
    }
  }
}