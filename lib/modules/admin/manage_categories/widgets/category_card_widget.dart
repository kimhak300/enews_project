import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart';
import 'package:newshub/api/model/category_model.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_categories/widgets/add_category_bottomsheet.dart';

class CategoryCardWidget extends StatelessWidget {
  final CategoryModel category;

  const CategoryCardWidget({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.find();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      color: theme.colorScheme.surface,
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
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
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
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) => AddCategoryBottomsheet(categoryToEdit: category),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit, color: theme.colorScheme.primary, size: 20),
                      ),
                    ),

                    SizedBox(width: AppSpacing.paddingS),

                    // ---- Delete Button (Parent Category) ----
                    GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                          title: "Delete Category",
                          middleText: "Are you sure you want to delete this category?",
                          onConfirm: () async {
                            Get.back(); // Close dialog first
                            await controller.deleteCategory(category.id);
                          },
                          onCancel: () {},
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.delete, color: theme.colorScheme.error, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Description
            if (category.description != null && category.description!.isNotEmpty)
              Text(category.description!, style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),

            const SizedBox(height: 8),

            // ------------ Subcategories ------------
            if (category.children.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subcategories:',
                    style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                  const SizedBox(height: 4),

                  ...category.children.map((sub) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(sub.name, style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
                          ),

                          Row(
                            children: [
                              // ---- Edit Subcategory ----
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.edit, color: theme.colorScheme.primary, size: 18),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: theme.colorScheme.error, size: 18),
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Delete Subcategory",
                                      middleText: "Are you sure you want to delete this subcategory?",
                                      onConfirm: () async {
                                        Get.back(); // Close dialog first
                                        await controller.deleteCategory(sub.id);
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