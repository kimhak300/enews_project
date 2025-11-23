import 'package:get/get.dart';
import 'package:newshub/sqflite_db/service/category_service.dart';
import '../model/category_model.dart';

class CategoryController extends GetxController {
  var categories = <CategoryModel>[].obs;
  final CategoryService _service = CategoryService();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    categories.value = await _service.getAllCategories();
  }

  void addCategory(CategoryModel category) async {
    await _service.insertCategory(category);
    fetchCategories();
  }

  void updateCategory(CategoryModel category) async {
    await _service.updateCategory(category);
    fetchCategories();
  }

  void deleteCategory(int id) async {
    await _service.deleteCategory(id);
    fetchCategories();
  }
}