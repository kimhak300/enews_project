import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../../../app/config/app_config.dart';

class OrgReportController extends GetxController {
  final ApiService _apiService = ApiService.to;
  final box = GetStorage();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Statistics
  final totalArticles = 0.obs;
  final publishedArticles = 0.obs;
  final draftArticles = 0.obs;
  final totalViews = 0.obs;
  final totalBookmarks = 0.obs;
  
  // Engagement metrics
  final totalLikes = 0.obs;
  final totalComments = 0.obs;
  final totalShares = 0.obs;
  final totalUsers = 0.obs;

  // Article performance
  final topArticles = <Map<String, dynamic>>[].obs;
  final recentArticles = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Try admin stats endpoint first (admin can view organizer data)
      final usedAdmin = await fetchAdminStatsIfAllowed();
      if (!usedAdmin) {
        // Fallback to organizer stats endpoint
        await fetchEngagementStats();
      }

      // Fetch articles
      final articlesResponse = await _apiService.getArticles();

      if (articlesResponse.isSuccess) {
        final articles = (articlesResponse.data['data'] as List?) ?? [];

        // Calculate statistics
        totalArticles.value = articles.length;
        publishedArticles.value =
            articles.where((a) => a['status'] == 'published').length;
        draftArticles.value =
            articles.where((a) => a['status'] == 'draft').length;

        // Calculate total views
        totalViews.value = articles.fold<int>(
          0,
          (sum, article) => sum + ((article['views_count'] as int?) ?? 0),
        );

        // Get top articles by views
        final sortedArticles = articles.toList();
        sortedArticles.sort((a, b) {
          final aViews = (a['views_count'] as int?) ?? 0;
          final bViews = (b['views_count'] as int?) ?? 0;
          return bViews.compareTo(aViews);
        });
        topArticles.value = sortedArticles
            .take(5)
            .cast<Map<String, dynamic>>()
            .toList();

        // Get recent articles
        recentArticles.value = articles
            .take(5)
            .cast<Map<String, dynamic>>()
            .toList();
      } else {
        errorMessage.value =
            articlesResponse.error ?? 'Failed to load report data';
      }

      // Fetch bookmarks count (if available)
      try {
        final bookmarksResponse = await _apiService.getBookmarks();
        if (bookmarksResponse.isSuccess) {
          // Handle different response structures
          if (bookmarksResponse.data is Map) {
            final data = bookmarksResponse.data;
            if (data['data'] is List) {
              final bookmarks = data['data'] as List;
              totalBookmarks.value = bookmarks.length;
            } else if (data['data'] is Map && data['data']['total'] != null) {
              totalBookmarks.value = data['data']['total'] as int;
            }
          } else if (bookmarksResponse.data is List) {
            totalBookmarks.value = (bookmarksResponse.data as List).length;
          }
        }
      } catch (e) {
        // Bookmarks endpoint might not be accessible, ignore error
        print('Bookmarks fetch error: $e');
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await fetchReportData();
  }
  
  Future<void> fetchEngagementStats() async {
    try {
      final token = box.read('token');
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/organizer/stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final stats = data['data'];
          totalLikes.value = stats['total_likes'] ?? 0;
          totalComments.value = stats['total_comments'] ?? 0;
          totalShares.value = stats['total_shares'] ?? 0;
          totalBookmarks.value = stats['total_bookmarks'] ?? 0;
          totalUsers.value = stats['total_users'] ?? 0;
          totalArticles.value = stats['total_articles'] ?? 0;
          publishedArticles.value = stats['published_articles'] ?? 0;
          draftArticles.value = stats['draft_articles'] ?? 0;
        }
      }
    } catch (e) {
      print('Error fetching engagement stats: $e');
    }
  }

  /// Attempt to call admin stats endpoint. Returns true if admin stats used.
  Future<bool> fetchAdminStatsIfAllowed() async {
    try {
      final token = box.read('token');
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/admin/stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final stats = data['data'];
          totalLikes.value = stats['total_likes'] ?? 0;
          totalComments.value = stats['total_comments'] ?? 0;
          totalShares.value = stats['total_shares'] ?? 0;
          totalBookmarks.value = stats['total_bookmarks'] ?? 0;
          totalUsers.value = stats['total_users'] ?? 0;
          totalArticles.value = stats['total_articles'] ?? 0;
          publishedArticles.value = stats['published_articles'] ?? 0;
          draftArticles.value = stats['draft_articles'] ?? 0;
          return true;
        }
      }
    } catch (e) {
      // likely not authorized for admin endpoint - ignore and fallback
      print('Admin stats fetch error or not allowed: $e');
    }
    return false;
  }
}