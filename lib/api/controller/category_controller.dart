import 'package:get/get.dart';
import 'package:newshub/api/model/category_model.dart';
import 'package:newshub/api/service/category_service.dart';

class CategoryController extends GetxController {
  final CategoryService service = CategoryService();

  var isLoading = false.obs;
  var categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  // Fetch all categories
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final result = await service.getCategories();
      categories.value = result;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Create category
  Future<void> createCategory({
    required String slug,
    required String name,
    String? description,
    int? parentId,
  }) async {
    try {
      isLoading.value = true;
      final category = await service.createCategory(
        slug: slug,
        name: name,
        description: description,
        parentId: parentId,
      );
      categories.add(category);
      Get.back();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Update category
  Future<void> updateCategory({
    required int id,
    required String slug,
    required String name,
    String? description,
    int? parentId,
  }) async {
    try {
      isLoading.value = true;
      final updated = await service.updateCategory(
        id: id,
        slug: slug,
        name: name,
        description: description,
        parentId: parentId,
      );

      final index = categories.indexWhere((c) => c.id == id);
      if (index != -1) {
        categories[index] = updated;
        categories.refresh();
      }

      Get.back();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Delete category
  Future<void> deleteCategory(int id) async {
    try {
      isLoading.value = true;
      await service.deleteCategory(id);

      categories.removeWhere((c) => c.id == id);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}