import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/button_nav/bottom_nav_bar/bottom_nav_controller.dart';
import 'package:newshub/modules/p1_home/home_view.dart';
import 'package:newshub/modules/p2_dashboard/dashboard_screen/dashboard_view.dart';
import 'package:newshub/modules/p3_search/search_screen/search_view.dart';
import 'package:newshub/modules/p5_profile/view/profile_view.dart';

class BottomNavView extends StatelessWidget {
  BottomNavView({super.key});

  final controller = Get.put(BottomNavController());

  final screens = [
    HomeView(),
    DashboardView(),
    Text(""),
    SearchView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: screens[controller.currentIndex.value],

      /// Center Floating Button for Post
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onPost,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      /// Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Icons.home_outlined,
                label: "Home",
                index: 0,
              ),
              _navItem(
                icon: Icons.dashboard_outlined,
                label: "Dash",
                index: 1,
              ),

              const SizedBox(width: 48),

              _navItem(
                icon: Icons.search_outlined,
                label: "Search",
                index: 3,
              ),
              _navItem(
                icon: Icons.person_outline,
                label: "Profile",
                index: 4,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return Obx(() {
      bool selected = controller.currentIndex.value == index;

      return InkWell(
        onTap: () => controller.changeTab(index),
        child: SizedBox(
          width: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected
                    ? Get.theme.colorScheme.primary
                    : Colors.grey.shade600,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Get.theme.colorScheme.primary
                      : Colors.grey.shade600,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}