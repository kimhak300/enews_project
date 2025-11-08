import '../models/article_model.dart';
import '../../core/constants/api_constants.dart';
import 'api_service.dart';

class BookmarkService {
  final ApiService _apiService = ApiService();

  // Get all bookmarks
  Future<List<ArticleModel>> getBookmarks() async {
    try {
      final response = await _apiService.get(ApiConstants.bookmarks);
      final List articlesJson = response.data['data'] ?? [];
      return articlesJson
          .map((json) => ArticleModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Toggle bookmark
  Future<bool> toggleBookmark(int articleId) async {
    try {
      final response = await _apiService.post(
        '${ApiConstants.toggleBookmark}/$articleId/toggle',
      );
      return response.data['bookmarked'] ?? false;
    } catch (e) {
      rethrow;
    }
  }

  // Add bookmark
  Future<void> addBookmark(int articleId) async {
    try {
      await _apiService.post('${ApiConstants.bookmarks}/$articleId');
    } catch (e) {
      rethrow;
    }
  }

  // Remove bookmark
  Future<void> removeBookmark(int articleId) async {
    try {
      await _apiService.delete('${ApiConstants.bookmarks}/$articleId');
    } catch (e) {
      rethrow;
    }
  }
}