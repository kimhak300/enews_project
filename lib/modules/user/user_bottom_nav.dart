import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/user/user_controller.dart';

class UserBottomNav extends StatelessWidget {
  final UserController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).bottomNavigationBarTheme.selectedItemColor ?? Theme.of(context).colorScheme.primary;
    final unselectedColor = Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ?? Theme.of(context).unselectedWidgetColor;
    final background = Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface;

    return Obx(
          () => Scaffold(
        body: controller.pages[controller.currentIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
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
                  icon: Icon(Icons.home),
                  label: 'home'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_library),
                  label: 'video'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_fire_department),
                  label: 'hot_news'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'profile'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}