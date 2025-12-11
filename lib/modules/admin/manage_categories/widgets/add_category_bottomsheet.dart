import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart';
import 'package:newshub/api/model/category_model.dart';

class AddCategoryBottomsheet extends StatefulWidget {
  final CategoryModel? categoryToEdit;

  const AddCategoryBottomsheet({super.key, this.categoryToEdit});

  @override
  State<AddCategoryBottomsheet> createState() => _AddCategoryBottomsheetState();
}

class _AddCategoryBottomsheetState extends State<AddCategoryBottomsheet> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final slugController = TextEditingController();
  final descriptionController = TextEditingController();

  // CategoryController
  final CategoryController categoryController = Get.find<CategoryController>();

  // Parent selection
  CategoryModel? selectedParent;

  @override
  void initState() {
    super.initState();
    if (widget.categoryToEdit != null) {
      // Edit mode: fill data
      final c = widget.categoryToEdit!;
      nameController.text = c.name;
      slugController.text = c.slug;
      descriptionController.text = c.description ?? '';
      selectedParent = categoryController.categories
          .firstWhereOrNull((cat) => cat.id == c.parentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final isEditMode = widget.categoryToEdit != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Obx(() => Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                isEditMode ? "edit_category".tr : "create_category".tr,
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.95)),
              ),
              const SizedBox(height: 20),

              // Parent Category Dropdown
              DropdownButtonFormField<CategoryModel>(
                decoration: _input(context, "parent_category".tr),
                value: selectedParent,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text("None"),
                  ),
                  ...categoryController.categories.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text(c.name, style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
                    );
                  }).toList(),
                ],
                onChanged: (value) => setState(() => selectedParent = value),
              ),
              const SizedBox(height: 16),

              // Category Name
              TextFormField(
                controller: nameController,
                style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                cursorColor: theme.colorScheme.primary,
                decoration: _input(context, "category_name".tr),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // Slug
              TextFormField(
                controller: slugController,
                style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                cursorColor: theme.colorScheme.primary,
                decoration: _input(context, "slug".tr),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                cursorColor: theme.colorScheme.primary,
                decoration: _input(context, "description".tr),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  onPressed: categoryController.isLoading.value
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      if (isEditMode) {
                        // Update category
                        await categoryController.updateCategory(
                          id: widget.categoryToEdit!.id,
                          slug: slugController.text.trim(),
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                          parentId: selectedParent?.id,
                        );
                      } else {
                        // Create category
                        await categoryController.createCategory(
                          slug: slugController.text.trim(),
                          name: nameController.text.trim(),
                          description:
                          descriptionController.text.trim(),
                          parentId: selectedParent?.id,
                        );
                      }
                    }
                  },
                  child: categoryController.isLoading.value
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.onPrimary,
                      strokeWidth: 2,
                    ),
                  ) : Text(
                    isEditMode ? "update_category".tr : "save_category".tr,
                    style: textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      )),
    );
  }

  InputDecoration _input(BuildContext context, String label) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
      filled: true,
      fillColor: theme.colorScheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}