import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/category_controller.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_categories/widgets/add_category_bottomsheet.dart';
import 'package:newshub/modules/admin/manage_categories/widgets/category_card_widget.dart';

/// Original organization profile view remains in other file; this file now
/// also exposes an organization-facing categories management view so that
/// organizers can see the same UI as admins for managing categories.

class OrgProfileView extends StatelessWidget {
  const OrgProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Keep a very small placeholder so profile route still works.
    return Scaffold(
      appBar: AppBar(title: const Text('Organization Profile')),
      body: const Center(child: Text('Organization profile (legacy)')),
    );
  }
}

class OrgCategoryView extends StatelessWidget {
  OrgCategoryView({super.key});

  final CategoryController controller =
      Get.isRegistered<CategoryController>() ? Get.find() : Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('manage_categories'.tr, style: textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary)),
        automaticallyImplyLeading: false,
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
