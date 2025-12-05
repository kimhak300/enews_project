import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/data/models/stats_model.dart';

class DashboardController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Loading state
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  // Stats data
  final Rxn<DashboardStatsModel> stats = Rxn<DashboardStatsModel>();

  // Quick stats for cards
  final totalUsers = 0.obs;
  final totalArticles = 0.obs;
  final totalCategories = 0.obs;
  final totalTags = 0.obs;

  // Recent data lists
  final RxList<RecentUser> recentUsers = <RecentUser>[].obs;
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
      final response = await _apiService.getAdminStats();

      if (response.isSuccess) {
        final data = response.data['data'];
        stats.value = DashboardStatsModel.fromJson(data);

        // Update individual values for easier access
        totalUsers.value = stats.value?.totalUsers ?? 0;
        totalArticles.value = stats.value?.totalArticles ?? 0;
        totalCategories.value = stats.value?.totalCategories ?? 0;
        totalTags.value = stats.value?.totalTags ?? 0;

        recentUsers.assignAll(stats.value?.recentUsers ?? []);
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