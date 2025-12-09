import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';

class OrgHomeController extends GetxController {
  final ApiService _apiService = ApiService.to;
  
  final isLoading = false.obs;
  final totalArticles = 0.obs;
  final publishedArticles = 0.obs;
  final draftArticles = 0.obs;
  final totalViews = 0.obs;
  final recentArticles = <Map<String, dynamic>>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardStats();
  }

  Future<void> fetchDashboardStats() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.getArticles();
      
      if (response.isSuccess) {
        final articles = (response.data['data'] as List?) ?? [];
        totalArticles.value = articles.length;
        publishedArticles.value = articles.where((a) => a['status'] == 'published').length;
        draftArticles.value = articles.where((a) => a['status'] == 'draft').length;
        recentArticles.value = articles.take(5).cast<Map<String, dynamic>>().toList();
      } else {
        errorMessage.value = response.error ?? 'Failed to load data';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await fetchDashboardStats();
  }
}