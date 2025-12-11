import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_categories/widgets/add_category_bottomsheet.dart';
import 'package:newshub/modules/admin/manage_categories/widgets/category_card_widget.dart';

/// Organization categories view — mirrors admin manage categories UI but
/// uses the same `CategoryController` so organization users see the same
/// categories as admin.
class OrgCategoryView extends StatelessWidget {
  OrgCategoryView({super.key});

  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('manage_categories'.tr, style: textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary)),
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text("add_category".tr, style: textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary)),
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
            return Center(child: Text("No categories found.", style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))));
          }

          // Pull-to-refresh
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchCategories();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: controller.categories
                .map((category) => CategoryCardWidget(category: category))
                .toList(),
            ),
          );
        }),
      ),
    );
  }
}
