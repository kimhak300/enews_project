import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart';
import 'package:newshub/api/model/category_model.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_categories/widgets/add_category_bottomsheet.dart';
import 'package:newshub/modules/admin/manage_categories/widgets/category_card_widget.dart';

class ManageCategoriesView extends StatelessWidget {
  ManageCategoriesView({super.key});

  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Category"),
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