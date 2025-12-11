import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/data/models/stats_model.dart';

class OrgHomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Loading state
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  // Stats data
  final Rxn<DashboardStatsModel> stats = Rxn<DashboardStatsModel>();

  // Quick stats for cards
  final totalArticles = 0.obs;
  final publishedArticles = 0.obs;
  final draftArticles = 0.obs;
  final totalViews = 0.obs;

  // Recent data lists
  final RxList<RecentArticle> recentArticles = <RecentArticle>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardStats();
  }

  Future<void> fetchDashboardStats() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiService.getOrgStats();

      if (response.isSuccess) {
        final data = response.data['data'];
        stats.value = DashboardStatsModel.fromJson(data);

        // Update individual values for easier access
        totalArticles.value = stats.value?.totalArticles ?? 0;
        publishedArticles.value = stats.value?.publishedArticles ?? 0;
        draftArticles.value = stats.value?.draftArticles ?? 0;
        totalViews.value = 0; // Will be updated when API provides this

        recentArticles.assignAll(stats.value?.recentArticles ?? []);
      } else {
        errorMessage.value = response.error ?? 'Failed to load dashboard data';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    fetchDashboardStats();
  }
}