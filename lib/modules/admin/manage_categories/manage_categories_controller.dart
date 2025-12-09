import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/data/models/article_model.dart';

class ManageCategoriesController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Loading state
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final isSaving = false.obs;

  // Categories list
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiService.getCategories();

      if (response.isSuccess) {
        // Handle different response formats
        List data;
        if (response.data is List) {
          data = response.data;
        } else if (response.data['data'] != null) {
          data = response.data['data'] as List;
        } else if (response.data['categories'] != null) {
          data = response.data['categories'] as List;
        } else if (response.data['value'] != null) {
          data = response.data['value'] as List;
        } else {
          data = [];
        }
        categories.assignAll(
          data.map((json) => CategoryModel.fromJson(json)).toList(),
        );
      } else {
        errorMessage.value = response.error ?? 'Failed to load categories';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    fetchCategories();
  }

  Future<void> createCategory() async {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Category name is required',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isSaving.value = true;

    try {
      final response = await _apiService.createCategory({
        'name': nameController.text,
        'description': descriptionController.text,
      });

      if (response.isSuccess) {
        Get.back();
        nameController.clear();
        descriptionController.clear();
        fetchCategories();
        Get.snackbar(
          'Success',
          'Category created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to create category',
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
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateCategory(int id) async {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Category name is required',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isSaving.value = true;

    try {
      final response = await _apiService.updateCategory(id, {
        'name': nameController.text,
        'description': descriptionController.text,
      });

      if (response.isSuccess) {
        Get.back();
        nameController.clear();
        descriptionController.clear();
        fetchCategories();
        Get.snackbar(
          'Success',
          'Category updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to update category',
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
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      final response = await _apiService.deleteCategory(categoryId);
      if (response.isSuccess) {
        categories.removeWhere((cat) => cat.id == categoryId);
        Get.snackbar(
          'Success',
          'Category deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to delete category',
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

  void showDeleteConfirmation(CategoryModel category) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              deleteCategory(category.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void showAddCategoryDialog() {
    nameController.clear();
    descriptionController.clear();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: isSaving.value ? null : createCategory,
                child: isSaving.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create'),
              )),
        ],
      ),
    );
  }

  void showEditCategoryDialog(CategoryModel category) {
    nameController.text = category.name;
    descriptionController.text = category.description ?? '';

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: isSaving.value ? null : () => updateCategory(category.id),
                child: isSaving.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Update'),
              )),
        ],
      ),
    );
  }
}