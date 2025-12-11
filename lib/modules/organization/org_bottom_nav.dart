import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/organization/org_controller.dart';

class OrgBottomNav extends StatelessWidget {
  final OrgController controller = Get.find();

  // color placeholders removed - will use theme values in build

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = theme.bottomNavigationBarTheme.selectedItemColor ??
        theme.colorScheme.primary;
    final unselectedColor =
        theme.bottomNavigationBarTheme.unselectedItemColor ??
            theme.unselectedWidgetColor;
    final background = theme.bottomNavigationBarTheme.backgroundColor ??
        theme.colorScheme.surface;

    return Obx(
      () => Scaffold(
        body: controller.pages[controller.currentIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.08),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, -2), // shadow on top
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: background,
              selectedItemColor: selectedColor,
              unselectedItemColor: unselectedColor,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'dashboard'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'articles'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'users'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: 'reports'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'categories'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
