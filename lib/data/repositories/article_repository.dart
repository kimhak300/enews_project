// import '../models/article_model.dart';
// import '../services/api_service.dart';
// import '../local/storage_service.dart';

// class ArticleRepository {
//   final ApiService _apiService = ApiService();
//   final StorageService _storage = StorageService();
  
//   static const String _bookmarksKey = 'bookmarked_articles';

//   // Fetch all articles
//   Future<List<ArticleModel>> getArticles() async {
//     return await _apiService.fetchArticles();
//   }

//   // Search articles
//   Future<List<ArticleModel>> searchArticles(String query) async {
//     return await _apiService.searchArticles(query);
//   }

//   // Get articles by category
//   Future<List<ArticleModel>> getArticlesByCategory(String category) async {
//     return await _apiService.getArticlesByCategory(category);
//   }

//   // Get article by ID
//   Future<ArticleModel?> getArticleById(String id) async {
//     return await _apiService.getArticleById(id);
//   }

//   // Bookmark management
//   Future<void> bookmarkArticle(ArticleModel article) async {
//     final bookmarks = getBookmarkedArticles();
//     if (!bookmarks.any((a) => a.id == article.id)) {
//       article.isBookmarked = true;
//       bookmarks.add(article);
//       await _storage.write(_bookmarksKey, bookmarks.map((a) => a.toJson()).toList());
//     }
//   }

//   Future<void> removeBookmark(String articleId) async {
//     final bookmarks = getBookmarkedArticles();
//     bookmarks.removeWhere((a) => a.id == articleId);
//     await _storage.write(_bookmarksKey, bookmarks.map((a) => a.toJson()).toList());
//   }

//   List<ArticleModel> getBookmarkedArticles() {
//     final bookmarksData = _storage.read<List>(_bookmarksKey);
//     if (bookmarksData == null) return [];
    
//     return bookmarksData
//         .map((json) => ArticleModel.fromJson(Map<String, dynamic>.from(json)))
//         .toList();
//   }

//   bool isBookmarked(String articleId) {
//     final bookmarks = getBookmarkedArticles();
//     return bookmarks.any((a) => a.id == articleId);
//   }

//   Future<void> toggleBookmark(ArticleModel article) async {
//     if (isBookmarked(article.id)) {
//       await removeBookmark(article.id);
//     } else {
//       await bookmarkArticle(article);
//     }
//   }
// }

import '../models/article_model.dart';
import '../services/article_service.dart';
import '../services/bookmark_service.dart';

class ArticleRepository {
  final ArticleService _articleService = ArticleService();
  final BookmarkService _bookmarkService = BookmarkService();

  // Fetch all articles
  Future<List<ArticleModel>> getArticles({int page = 1, int perPage = 10}) async {
    return await _articleService.getArticles(page: page, perPage: perPage);
  }

  // Get trending articles
  Future<List<ArticleModel>> getTrending() async {
    return await _articleService.getTrendingArticles();
  }

  // Get latest articles
  Future<List<ArticleModel>> getLatest() async {
    return await _articleService.getLatestArticles();
  }

  // Search articles
  Future<List<ArticleModel>> searchArticles(String query) async {
    return await _articleService.searchArticles(query);
  }

  // Get articles by category
  Future<List<ArticleModel>> getArticlesByCategory(String categorySlug) async {
    return await _articleService.getArticlesByCategory(categorySlug);
  }

  // Get article by ID
  Future<ArticleModel> getArticleById(int id) async {
    return await _articleService.getArticleById(id);
  }

  // Increment view
  Future<void> incrementView(int articleId) async {
    await _articleService.incrementView(articleId);
  }

  // Bookmark management
  Future<bool> toggleBookmark(int articleId) async {
    return await _bookmarkService.toggleBookmark(articleId);
  }

  Future<List<ArticleModel>> getBookmarkedArticles() async {
    return await _bookmarkService.getBookmarks();
  }
}
