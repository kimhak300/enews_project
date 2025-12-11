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

  /// Check if article is liked by current user
  Future<bool> checkIfLiked(int articleId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reactions'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reactions = (data is List) ? data : (data['data'] as List? ?? []);
        return reactions.any((reaction) {
          final reactionArticleId = reaction['article_id'];
          return reactionArticleId != null && reactionArticleId == articleId;
        });
      }
      return false;
    } catch (e) {
      print('❌ Error checking like status: $e');
      return false;
    }
  }

  /// Share article → tracked in backend Share table → counted in admin analytics
  /// Platform can be: 'facebook', 'twitter', 'copy_link', 'whatsapp', etc.
  Future<Map<String, dynamic>> trackShare(int articleId, {String? platform}) async {
    try {
      print('🔗 Tracking share for article: $articleId, platform: $platform');
      final response = await http.post(
        Uri.parse('$baseUrl/shares'),
        headers: headers,
        body: jsonEncode({
          'article_id': articleId,
          'platform': platform,
        }),
      );

      print('🔗 Share track response: ${response.statusCode}');
      print('🔗 Share track body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to track share: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('❌ Error tracking share: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get article stats (likes, comments, shares)
  Future<Map<String, dynamic>> getArticleStats(int articleId) async {
    try {
      print('📊 Getting article stats for: $articleId');
      final response = await http.get(
        Uri.parse('$baseUrl/articles/$articleId/stats'),
        headers: headers,
      );

      print('📊 Stats response: ${response.statusCode}');
      print('📊 Stats body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'error': 'Failed to get stats: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('❌ Error getting article stats: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
