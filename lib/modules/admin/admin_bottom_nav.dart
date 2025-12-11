import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/admin/admin_controller.dart';

class AdminBottomNav extends StatelessWidget {

  final AdminController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.bottomNavigationBarTheme.backgroundColor ?? theme.colorScheme.surface;
    final selectedColor = theme.bottomNavigationBarTheme.selectedItemColor ?? theme.colorScheme.primary;
    final unselectedColor = theme.bottomNavigationBarTheme.unselectedItemColor ?? theme.colorScheme.onSurface.withOpacity(0.6);

    return Obx(
      () => Scaffold(
        body: controller.pages[controller.currentIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.06),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: bg,
              selectedItemColor: selectedColor,
              unselectedItemColor: unselectedColor,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'dashboard'.tr),
                BottomNavigationBarItem(icon: Icon(Icons.people), label: 'users'.tr),
                BottomNavigationBarItem(icon: Icon(Icons.article), label: 'articles'.tr),
                BottomNavigationBarItem(icon: Icon(Icons.category), label: 'categories'.tr),
                BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'reports'.tr),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
