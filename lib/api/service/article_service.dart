import 'dart:convert';
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

    final response = await http.post(
      Uri.parse('$baseUrl/articles'),
      headers: AppConstants.headers(token),
      body: jsonEncode(body),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create article: ${response.body}');
    }
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
      throw Exception('Failed to update article: ${response.body}');
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
      throw Exception('Failed to delete article: ${response.body}');
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