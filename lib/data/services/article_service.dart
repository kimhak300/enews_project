import '../models/article_model.dart';
import '../../core/constants/api_constants.dart';
import 'api_service.dart';

class ArticleService {
  final ApiService _apiService = ApiService();

  // Get all articles with pagination
  Future<List<ArticleModel>> getArticles({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.articles,
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      final List articlesJson = response.data['data'] ?? [];
      return articlesJson
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get trending articles
  Future<List<ArticleModel>> getTrendingArticles() async {
    try {
      final response = await _apiService.get(ApiConstants.trending);
      final List articlesJson = response.data['data'] ?? [];
      return articlesJson
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get latest articles
  Future<List<ArticleModel>> getLatestArticles() async {
    try {
      final response = await _apiService.get(ApiConstants.latest);
      final List articlesJson = response.data['data'] ?? [];
      return articlesJson
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get article by ID
  Future<ArticleModel> getArticleById(int id) async {
    try {
      final response = await _apiService.get('${ApiConstants.articleById}/$id');
      return ArticleModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  // Get articles by category
  Future<List<ArticleModel>> getArticlesByCategory(String categorySlug) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.articlesByCategory}/$categorySlug',
      );
      final List articlesJson = response.data['data'] ?? [];
      return articlesJson
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Search articles
  Future<List<ArticleModel>> searchArticles(String query) async {
    try {
      final response = await _apiService.get(
        ApiConstants.search,
        queryParameters: {'q': query},
      );
      final List articlesJson = response.data['data'] ?? [];
      return articlesJson
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Increment article view
  Future<void> incrementView(int articleId) async {
    try {
      await _apiService.post('${ApiConstants.incrementView}/$articleId/view');
    } catch (e) {
      // Silently fail - not critical
      print('Failed to increment view: $e');
    }
  }
}