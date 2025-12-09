import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';

class OrgReportController extends GetxController {
  final ApiService _apiService = ApiService.to;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Statistics
  final totalArticles = 0.obs;
  final publishedArticles = 0.obs;
  final draftArticles = 0.obs;
  final totalViews = 0.obs;
  final totalBookmarks = 0.obs;

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
}