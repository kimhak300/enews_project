import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newshub/api/model/category_model.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:get_storage/get_storage.dart';

class CategoryService {
  final storage = GetStorage();

  String get token {
    final storedToken = storage.read(AppConstants.TOKEN_KEY);
    print('CategoryService - Token retrieved: ${storedToken != null ? "${storedToken.toString().substring(0, 20)}..." : "NULL"}');
    return storedToken ?? '';
  }

  // Get all categories
  Future<List<CategoryModel>> getCategories() async {
    final url = Uri.parse("${AppConstants.BASE_URL}/categories");

    final response = await http.get(
      url,
      headers: AppConstants.headers(token),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List data = jsonData['categories'] ?? [];
      return data.map((c) => CategoryModel.fromJson(c)).toList();
    } else {
      throw Exception("Failed to load categories: ${response.body}");
    }
  }

  // Create category
  Future<CategoryModel> createCategory({
    required String slug,
    required String name,
    String? description,
    int? parentId,
  }) async {
    final currentToken = token;
    if (currentToken.isEmpty) {
      throw Exception("Not authenticated. Please login first.");
    }

    final url = Uri.parse("${AppConstants.BASE_URL}/categories");

    final body = {
      "slug": slug,
      "name": name,
      "description": description,
      "parent_id": parentId,
    };

    print('CategoryService - Creating category with token: ${currentToken.substring(0, 20)}...');
    print('CategoryService - Request body: $body');

    final response = await http.post(
      url,
      headers: AppConstants.headers(currentToken),
      body: jsonEncode(body),
    );

    print('CategoryService - Response status: ${response.statusCode}');
    print('CategoryService - Response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return CategoryModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception("Session expired. Please login again.");
    } else {
      throw Exception("Failed to create category: ${response.body}");
    }
  }

  // Update category
  Future<CategoryModel> updateCategory({
    required int id,
    required String slug,
    required String name,
    String? description,
    int? parentId,
  }) async {
    final url = Uri.parse("${AppConstants.BASE_URL}/categories/$id");

    final body = {
      "slug": slug,
      "name": name,
      "description": description,
      "parent_id": parentId,
    };

    final response = await http.put(
      url,
      headers: AppConstants.headers(token),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return CategoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update category: ${response.body}");
    }
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    final url = Uri.parse("${AppConstants.BASE_URL}/categories/$id");

    final response = await http.delete(
      url,
      headers: AppConstants.headers(token),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to delete category: ${response.body}");
    }
  }
}