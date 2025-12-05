import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/data/models/user_model.dart';

class ManageUsersController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Loading states
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  // Pagination
  int currentPage = 1;
  bool hasMore = true;

  // Users list
  final RxList<UserModel> users = <UserModel>[].obs;

  // Search & Filter
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchUsers({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMore = true;
      users.clear();
    }

    if (!hasMore && !refresh) return;

    if (currentPage == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _apiService.getUsers(page: currentPage);

      if (response.isSuccess) {
        final data = response.data['data'] as List? ?? [];
        final newUsers = data.map((json) => UserModel.fromJson(json)).toList();

        if (newUsers.isEmpty) {
          hasMore = false;
        } else {
          users.addAll(newUsers);
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
    // Filter locally or call API with search param
    // For now, filtering locally
  }

  List<UserModel> get filteredUsers {
    if (searchQuery.value.isEmpty) return users;
    return users.where((user) {
      final query = searchQuery.value.toLowerCase();
      return user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> deleteUser(int userId) async {
    try {
      final response = await _apiService.deleteUser(userId);
      if (response.isSuccess) {
        users.removeWhere((user) => user.id == userId);
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