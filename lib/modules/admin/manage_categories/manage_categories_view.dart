import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart';
import 'package:newshub/api/model/category_model.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_categories/widgets/add_category_bottomsheet.dart';

class ManageCategoriesView extends StatelessWidget {
  ManageCategoriesView({super.key});

  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const AddCategoryBottomsheet(),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingS),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.categories.isEmpty) {
            return const Center(child: Text("No categories found."));
          }

          // Pull-to-refresh
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchCategories();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: controller.categories
                  .map((category) =>
                  CategoryCardWidget(category: category, textTheme: textTheme))
                  .toList(),
            ),
          );
        }),
      ),
    );
  }
}

// --------------------------
// Category Card Widget
// --------------------------
class CategoryCardWidget extends StatelessWidget {
  final CategoryModel category;
  final TextTheme textTheme;

  const CategoryCardWidget({
    super.key,
    required this.category,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.find();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Name + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  // Edit Category
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) =>
                            AddCategoryBottomsheet(categoryToEdit: category),
                      );
                    },
                  ),
                  // Delete Category
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Delete Category",
                        middleText:
                        "Are you sure you want to delete this category?",
                        onConfirm: () async {
                          await controller.deleteCategory(category.id);
                          Get.back();
                        },
                        onCancel: () {},
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Description
          if (category.description != null && category.description!.isNotEmpty)
            Text(category.description!, style: textTheme.bodyMedium),

          const SizedBox(height: 8),

          // Subcategories
          if (category.children.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subcategories:',
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ...category.children.map((sub) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(sub.name, style: textTheme.bodyMedium)),
                        Row(
                          children: [
                            // Edit Subcategory
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueAccent, size: 20),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  builder: (_) => AddCategoryBottomsheet(
                                      categoryToEdit: sub),
                                );
                              },
                            ),
                            // Delete Subcategory
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent, size: 20),
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "Delete Subcategory",
                                  middleText:
                                  "Are you sure you want to delete this subcategory?",
                                  onConfirm: () async {
                                    await controller.deleteCategory(sub.id);
                                    Get.back();
                                  },
                                  onCancel: () {},
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }
}