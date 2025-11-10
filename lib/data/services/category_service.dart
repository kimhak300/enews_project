import '../models/category_model.dart';
import '../../app/config/api_constants.dart';
import 'api_service.dart';

class CategoryService {
  final ApiService _apiService = ApiService();

  // Get all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiService.get(ApiConstants.categories);
      final List categoriesJson = response.data['data'] ?? [];
      return categoriesJson
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get category by slug
  Future<CategoryModel> getCategoryBySlug(String slug) async {
    try {
      final response = await _apiService.get('${ApiConstants.categoryBySlug}/$slug');
      return CategoryModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}