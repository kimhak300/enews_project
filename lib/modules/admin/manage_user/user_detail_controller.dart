import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/data/models/user_model.dart';

class UserDetailController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();

  late final int userId;

  @override
  void onInit() {
    super.onInit();
    // Get userId from arguments
    userId = Get.arguments as int;
    fetchUserDetail();
  }

  Future<void> fetchUserDetail() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiService.get('/users/$userId');
      
      if (response.isSuccess && response.data != null) {
        final userData = response.data['data'] ?? response.data;
        user.value = UserModel.fromJson(userData);
      } else {
        errorMessage.value = response.error ?? 'Failed to load user details';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    fetchUserDetail();
  }

  String getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'administrator'.tr;
      case 'organizer':
      case 'organization':
        return 'organization'.tr;
      case 'user':
      default:
        return 'user'.tr;
    }
  }

  String getStatusDisplayName(String? status) {
    if (status == null || status.isEmpty) return 'active'.tr;
    
    switch (status.toLowerCase()) {
      case 'active':
        return 'active'.tr;
      case 'inactive':
        return 'inactive'.tr;
      case 'banned':
        return 'banned'.tr;
      default:
        return status;
    }
  }
}
