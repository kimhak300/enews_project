import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../app/constants/app_constant.dart';

class ArticleInteractionService {
  static final ArticleInteractionService _instance = ArticleInteractionService._internal();
  factory ArticleInteractionService() => _instance;
  ArticleInteractionService._internal();

  final String baseUrl = AppConstants.BASE_URL;
  final GetStorage storage = GetStorage();

  String? get token => storage.read(AppConstants.TOKEN_KEY);

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Like an article (adds to Reaction table → counted in admin analytics)
  Future<Map<String, dynamic>> likeArticle(int articleId) async {
    try {
      print('🔵 Liking article: $articleId');
      final response = await http.post(
        Uri.parse('$baseUrl/reactions'),
        headers: headers,
        body: jsonEncode({
          'article_id': articleId,
          'reaction_type': 'like',
        }),
      );

      print('🔵 Like response: ${response.statusCode}');
      print('🔵 Like body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to like article: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('❌ Error liking article: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Unlike an article (removes from Reaction table → decreases admin analytics count)
  Future<Map<String, dynamic>> unlikeArticle(int articleId) async {
    try {
      print('🔵 Unliking article: $articleId');
      final response = await http.delete(
        Uri.parse('$baseUrl/reactions'),
        headers: headers,
        body: jsonEncode({
          'article_id': articleId,
          'reaction_type': 'like',
        }),
      );

      print('🔵 Unlike response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to unlike article',
        };
      }
    } catch (e) {
      print('❌ Error unliking article: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Add bookmark (adds to UserBookmark table → counted in admin analytics)
  Future<Map<String, dynamic>> addBookmark(int articleId) async {
    try {
      print('🟢 Adding bookmark for article: $articleId');
      final response = await http.post(
        Uri.parse('$baseUrl/bookmark'),
        headers: headers,
        body: jsonEncode({
          'article_id': articleId,
        }),
      );

      print('🟢 Bookmark response: ${response.statusCode}');
      print('🟢 Bookmark body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to bookmark article',
        };
      }
    } catch (e) {
      print('❌ Error bookmarking article: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Remove bookmark (removes from UserBookmark table → decreases admin analytics count)
  Future<Map<String, dynamic>> removeBookmark(int articleId) async {
    try {
      print('🟢 Removing bookmark for article: $articleId');
      final response = await http.delete(
        Uri.parse('$baseUrl/bookmark/$articleId'),
        headers: headers,
      );

      print('🟢 Remove bookmark response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to remove bookmark',
        };
      }
    } catch (e) {
      print('❌ Error removing bookmark: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Post a comment (adds to Comment table → counted in admin analytics)
  Future<Map<String, dynamic>> postComment(int articleId, String content) async {
    try {
      print('🟡 Posting comment for article: $articleId');
      final response = await http.post(
        Uri.parse('$baseUrl/comments'),
        headers: headers,
        body: jsonEncode({
          'article_id': articleId,
          'content_text': content,
        }),
      );

      print('🟡 Comment response: ${response.statusCode}');
      print('🟡 Comment body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to post comment',
        };
      }
    } catch (e) {
      print('❌ Error posting comment: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get comments for an article
  Future<Map<String, dynamic>> getComments(int articleId) async {
    try {
      print('🟡 Getting comments for article: $articleId');
      final response = await http.get(
        Uri.parse('$baseUrl/comments/$articleId'),
        headers: headers,
      );

      print('🟡 Get comments response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // API returns array directly, wrap it in data structure for consistency
        final comments = (responseData is List) ? responseData : (responseData['data'] ?? responseData);
        return {
          'success': true,
          'data': {'data': comments},
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to get comments',
        };
      }
    } catch (e) {
      print('❌ Error getting comments: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Check if article is bookmarked
  Future<bool> checkIfBookmarked(int articleId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookmarks'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // API returns array directly, not wrapped in 'data'
        final bookmarks = (data is List) ? data : (data['data'] as List? ?? []);
        return bookmarks.any((bookmark) {
          // API returns article_id directly, not nested article object
          final bookmarkArticleId = bookmark['article_id'];
          return bookmarkArticleId != null && bookmarkArticleId == articleId;
        });
      }
      return false;
    } catch (e) {
      print('❌ Error checking bookmark: $e');
      return false;
    }
  }

  /// Share article (currently client-side only, but can track in future)
  /// Note: Shares are tracked client-side for now. 
  /// In the future, add a backend endpoint to track share counts
  Future<void> trackShare(int articleId) async {
    // TODO: Add backend endpoint to track shares
    // This would add to a Share table → counted in admin analytics
    print('🔗 Share tracked for article: $articleId (client-side only)');
  }
}
