import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/organization/org_controller.dart';

class OrgBottomNav extends StatelessWidget {
  final OrgController controller = Get.find();

  final Color selectedColor = Colors.blueAccent;
  final Color unselectedColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: controller.pages[controller.currentIndex.value],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, -2), // shadow on top
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: selectedColor,
              unselectedItemColor: unselectedColor,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Article',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'Team',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Report',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
