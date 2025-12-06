import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart';
import 'package:newshub/api/model/category_model.dart';

class AddCategoryBottomsheet extends StatefulWidget {
  final CategoryModel? categoryToEdit; // Optional: for edit mode

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
    final textTheme = Theme.of(context).textTheme;

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
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                isEditMode ? "Edit Category" : "Create Category",
                style: textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Parent Category Dropdown
              DropdownButtonFormField<CategoryModel>(
                decoration: _input("Parent Category"),
                value: selectedParent,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text("None"),
                  ),
                  ...categoryController.categories.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text(c.name, style: textTheme.bodyMedium),
                    );
                  }).toList(),
                ],
                onChanged: (value) => setState(() => selectedParent = value),
              ),
              const SizedBox(height: 16),

              // Category Name
              TextFormField(
                controller: nameController,
                decoration: _input("Category Name"),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // Slug
              TextFormField(
                controller: slugController,
                decoration: _input("Slug"),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: _input("Description"),
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
                    backgroundColor: Colors.blueAccent,
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
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ) : Text(
                    isEditMode ? "Update Category" : "Save Category",
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
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

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}