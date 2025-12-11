import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart';

/// Organization category controller — reuses the shared `CategoryController`
/// so organization users see the same categories as admin (read-only by default).
class OrgCategoryController extends GetxController {
  late final CategoryController categoryController;

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<CategoryController>()) {
      Get.put(CategoryController());
    }
    categoryController = Get.find<CategoryController>();
  }

  /// Refresh categories (delegates to shared controller)
  Future<void> refresh() async {
    await categoryController.fetchCategories();
  }
}