import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/data/models/user_model.dart';

class ManageUsersController extends GetxController with GetTickerProviderStateMixin {
  final ApiService _apiService = Get.find<ApiService>();

  // Tab Controller
  late TabController tabController;

  // Loading states
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  // Pagination
  int currentPage = 1;
  bool hasMore = true;

  // Users list
  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxList<UserModel> userRoleUsers = <UserModel>[].obs;
  final RxList<UserModel> organizerUsers = <UserModel>[].obs;

  // Search & Filter
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedRole = Rxn<String>(); // 'all', 'user', 'admin', 'organizer'

  // Roles list
  final RxList<RoleModel> roles = <RoleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabChange);
    fetchRoles();
    fetchUsers();
  }

  @override
  void onClose() {
    searchController.dispose();
    tabController.dispose();
    super.onClose();
  }

  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      // Update selected role based on tab
      switch (tabController.index) {
        case 0:
          selectedRole.value = null; // All
          break;
        case 1:
          selectedRole.value = 'user';
          break;
        case 2:
          selectedRole.value = 'organizer';
          break;
      }
      refresh();
    }
  }

  Future<void> fetchRoles() async {
    try {
      final response = await _apiService.getRoles();
      if (response.isSuccess) {
        final data = response.data is List ? response.data : (response.data['data'] ?? []);
        roles.assignAll(
          (data as List).map((json) => RoleModel.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> fetchUsers({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMore = true;
      allUsers.clear();
      userRoleUsers.clear();
      organizerUsers.clear();
    }

    if (!hasMore && !refresh) return;

    if (currentPage == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _apiService.getUsers(
        page: currentPage,
        role: selectedRole.value,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (response.isSuccess) {
        final data = response.data['data'] as List? ?? [];
        final newUsers = data.map((json) => UserModel.fromJson(json)).toList();

        if (newUsers.isEmpty) {
          hasMore = false;
        } else {
          if (selectedRole.value == null) {
            allUsers.addAll(newUsers);
          } else if (selectedRole.value == 'user') {
            userRoleUsers.addAll(newUsers);
          } else if (selectedRole.value == 'organizer') {
            organizerUsers.addAll(newUsers);
          }
          currentPage++;
        }
      } else {
        errorMessage.value = response.error ?? 'Failed to load users';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.createUser(userData);
      if (response.isSuccess) {
        Get.snackbar('Success', 'User created successfully',
            snackPosition: SnackPosition.BOTTOM);
        refresh();
      } else {
        Get.snackbar('Error', response.error ?? 'Failed to create user',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.updateUser(userId, userData);
      if (response.isSuccess) {
        Get.snackbar('Success', 'User updated successfully',
            snackPosition: SnackPosition.BOTTOM);
        refresh();
      } else {
        Get.snackbar('Error', response.error ?? 'Failed to update user',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> assignRoleToUser(int userId, int roleId) async {
    try {
      final response = await _apiService.assignRole(userId, roleId);
      if (response.isSuccess) {
        Get.snackbar('Success', 'Role assigned successfully',
            snackPosition: SnackPosition.BOTTOM);
        refresh();
      } else {
        Get.snackbar('Error', response.error ?? 'Failed to assign role',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> removeRoleFromUser(int userId, int roleId) async {
    try {
      final response = await _apiService.removeRole(userId, roleId);
      if (response.isSuccess) {
        Get.snackbar('Success', 'Role removed successfully',
            snackPosition: SnackPosition.BOTTOM);
        refresh();
      } else {
        Get.snackbar('Error', response.error ?? 'Failed to remove role',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void loadMore() {
    if (!isLoadingMore.value && hasMore) {
      fetchUsers();
    }
  }

  void refresh() {
    fetchUsers(refresh: true);
  }

  void searchUsers(String query) {
    searchQuery.value = query;
    refresh();
  }

  List<UserModel> get currentTabUsers {
    switch (tabController.index) {
      case 0:
        return allUsers;
      case 1:
        return userRoleUsers;
      case 2:
        return organizerUsers;
      default:
        return allUsers;
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      final response = await _apiService.deleteUser(userId);
      if (response.isSuccess) {
        // Remove from all lists
        allUsers.removeWhere((user) => user.id == userId);
        userRoleUsers.removeWhere((user) => user.id == userId);
        organizerUsers.removeWhere((user) => user.id == userId);
        Get.snackbar(
          'Success',
          'User deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to delete user',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showDeleteConfirmation(UserModel user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              deleteUser(user.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}