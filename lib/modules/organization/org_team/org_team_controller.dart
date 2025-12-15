import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/app/routes/app_routes.dart';

class OrgTeamController extends GetxController {
  final ApiService _apiService = ApiService.to;

  final isLoading = false.obs;
  final teamMembers = <Map<String, dynamic>>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeamMembers();
  }

  Future<void> fetchTeamMembers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.getUsers();

      if (response.isSuccess) {
        final users = (response.data['data'] as List?) ?? [];
        // Filter for organization members (you can adjust this filter)
        teamMembers.value = users
            .where((user) => user['role'] == 'organizer' || user['role'] == 'user')
            .cast<Map<String, dynamic>>()
            .toList();
      } else {
        errorMessage.value = response.error ?? 'Failed to load team members';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await fetchTeamMembers();
  }

  void viewMemberDetails(Map<String, dynamic> member) {
    // Navigate to user detail screen
    final userId = member['id'];
    if (userId != null) {
      Get.toNamed(Routes.ORG_USER_DETAIL, arguments: userId);
    }
  }
}