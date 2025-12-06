import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart';
import 'package:newshub/api/model/category_model.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_categories/widgets/add_category_bottomsheet.dart';

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

    return Card(
      child: Container(
        padding: const EdgeInsets.all(12),
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
                    // ---- Edit Button (Parent Category) ----
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          builder: (_) =>
                              AddCategoryBottomsheet(categoryToEdit: category),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE3F2FD), // light blue
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            color: Colors.blueAccent, size: 20),
                      ),
                    ),

                    SizedBox(width: AppSpacing.paddingS),

                    // ---- Delete Button (Parent Category) ----
                    GestureDetector(
                      onTap: () {
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
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFEBEE), // light red
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delete,
                            color: Colors.redAccent, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Description
            if (category.description != null &&
                category.description!.isNotEmpty)
              Text(category.description!, style: textTheme.bodyMedium),

            const SizedBox(height: 8),

            // ------------ Subcategories ------------
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
                            child:
                            Text(sub.name, style: textTheme.bodyMedium),
                          ),

                          Row(
                            children: [
                              // ---- Edit Subcategory ----
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE3F2FD), // light blue
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blueAccent, size: 18),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (_) => AddCategoryBottomsheet(
                                        categoryToEdit: sub,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 6),

                              // ---- Delete Subcategory ----
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFEBEE), // light red
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent, size: 18),
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Delete Subcategory",
                                      middleText:
                                      "Are you sure you want to delete this subcategory?",
                                      onConfirm: () async {
                                        await controller
                                            .deleteCategory(sub.id);
                                        Get.back();
                                      },
                                      onCancel: () {},
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}