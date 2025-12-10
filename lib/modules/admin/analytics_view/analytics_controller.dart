import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../../../app/config/app_config.dart';

class AnalyticsController extends GetxController {
  final box = GetStorage();
  
  var isLoading = false.obs;
  var totalLikes = 0.obs;
  var totalComments = 0.obs;
  var totalShares = 0.obs;
  var totalBookmarks = 0.obs;
  var totalUsers = 0.obs;
  var totalArticles = 0.obs;
  var publishedArticles = 0.obs;
  var draftArticles = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }
  
  Future<void> fetchStats() async {
    try {
      isLoading(true);
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
}