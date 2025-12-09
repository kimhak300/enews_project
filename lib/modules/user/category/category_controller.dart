import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';

class UserCategoryController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = false.obs;
  final categories = <Map<String, dynamic>>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.getCategories();

      if (response.isSuccess) {
        // Handle different response formats
        if (response.data is List) {
          categories.value = (response.data as List).cast<Map<String, dynamic>>();
        } else if (response.data is Map && response.data['data'] != null) {
          final data = response.data['data'];
          if (data is List) {
            categories.value = data.cast<Map<String, dynamic>>();
          }
        }
      } else {
        errorMessage.value = response.error ?? 'Failed to load categories';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await fetchCategories();
  }

  void navigateToCategoryArticles(Map<String, dynamic> category) {
    // Navigate to articles filtered by this category
    Get.toNamed('/category-articles', arguments: {'category': category});
  }
}
