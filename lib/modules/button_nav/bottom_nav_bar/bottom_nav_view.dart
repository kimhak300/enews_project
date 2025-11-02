import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/button_nav/bottom_nav_bar/bottom_nav_controller.dart';
import '../../p1_home/home_controller.dart';

class BottomNavView extends GetView<HomeController> {
   BottomNavView({Key? key}) : super(key: key);

    final BottomNavController bottomNavController = Get.put(BottomNavController());

  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          onTap: (index) {
            controller.handleNavigation(index);
          },
          type: BottomNavigationBarType.fixed,
      // Defer background to theme so it switches in dark mode
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          elevation: 8.0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: 'home'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard),
              label: 'dashboard'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search_outlined),
              activeIcon: const Icon(Icons.search),
              label: 'search'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bookmark_outline),
              activeIcon: const Icon(Icons.bookmark),
              label: 'saved'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: 'profile'.tr,
            ),
          ],
        ));
  }
}
