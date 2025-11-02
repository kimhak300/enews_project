import '../models/article_model.dart';
import '../services/api_service.dart';
import '../local/storage_service.dart';

class ArticleRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();
  
  static const String _bookmarksKey = 'bookmarked_articles';

  // Fetch all articles
  Future<List<ArticleModel>> getArticles() async {
    return await _apiService.fetchArticles();
  }

  // Search articles
  Future<List<ArticleModel>> searchArticles(String query) async {
    return await _apiService.searchArticles(query);
  }

  // Get articles by category
  Future<List<ArticleModel>> getArticlesByCategory(String category) async {
    return await _apiService.getArticlesByCategory(category);
  }

  // Get article by ID
  Future<ArticleModel?> getArticleById(String id) async {
    return await _apiService.getArticleById(id);
  }

  // Bookmark management
  Future<void> bookmarkArticle(ArticleModel article) async {
    final bookmarks = getBookmarkedArticles();
    if (!bookmarks.any((a) => a.id == article.id)) {
      article.isBookmarked = true;
      bookmarks.add(article);
      await _storage.write(_bookmarksKey, bookmarks.map((a) => a.toJson()).toList());
    }
  }

  Future<void> removeBookmark(String articleId) async {
    final bookmarks = getBookmarkedArticles();
    bookmarks.removeWhere((a) => a.id == articleId);
    await _storage.write(_bookmarksKey, bookmarks.map((a) => a.toJson()).toList());
  }

  List<ArticleModel> getBookmarkedArticles() {
    final bookmarksData = _storage.read<List>(_bookmarksKey);
    if (bookmarksData == null) return [];
    
    return bookmarksData
        .map((json) => ArticleModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  bool isBookmarked(String articleId) {
    final bookmarks = getBookmarkedArticles();
    return bookmarks.any((a) => a.id == articleId);
  }

  Future<void> toggleBookmark(ArticleModel article) async {
    if (isBookmarked(article.id)) {
      await removeBookmark(article.id);
    } else {
      await bookmarkArticle(article);
    }
  }
}
