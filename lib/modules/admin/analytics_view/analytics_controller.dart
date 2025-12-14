import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../../../app/config/app_config.dart';
import '../../../app/constants/app_constant.dart';

class AnalyticsController extends GetxController {
  final box = GetStorage();
  
  var isLoading = false.obs;
  var totalLikes = 0.obs;
  var totalComments = 0.obs;
  var totalShares = 0.obs;
  var totalBookmarks = 0.obs;
  var totalUsers = 0.obs;
  var totalArticles = 0.obs;
  var totalViews = 0.obs;
  var publishedArticles = 0.obs;
  var draftArticles = 0.obs;
  
  @override
  void onReady() {
    super.onReady();
    fetchStats();
  }
  
  Future<void> fetchStats() async {
    try {
      isLoading(true);
      final token = box.read(AppConstants.TOKEN_KEY);
      
      // Debug: Print token status
      print('Analytics - Token exists: ${token != null}, isEmpty: ${token?.isEmpty ?? true}');
      print('Analytics - Token length: ${token?.length ?? 0}');
      
      // Check if token exists
      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Not Logged In',
          'Please login to view analytics',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
      
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/admin/stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      // Debug: Print response
      print('Analytics - Response status: ${response.statusCode}');
      print('Analytics - Response body: ${response.body}');
      
      // Check for 401 Unauthorized
      if (response.statusCode == 401) {
        Get.snackbar(
          'Session Expired',
          'Your session has expired. Please login again.',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final stats = data['data'];
          totalLikes.value = _parseInt(stats['total_likes']);
          totalComments.value = _parseInt(stats['total_comments']);
          totalShares.value = _parseInt(stats['total_shares']);
          totalBookmarks.value = _parseInt(stats['total_bookmarks']);
          totalUsers.value = _parseInt(stats['total_users']);
          totalArticles.value = _parseInt(stats['total_articles']);
          totalViews.value = _parseInt(stats['total_views']);
          publishedArticles.value = _parseInt(stats['published_articles']);
          draftArticles.value = _parseInt(stats['draft_articles']);
        } else {
          Get.snackbar('Error', data['message'] ?? 'Failed to load analytics data');
        }
      } else {
        Get.snackbar('Error', 'Failed to load analytics data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error fetching stats: $e');
    } finally {
      isLoading(false);
    }
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}