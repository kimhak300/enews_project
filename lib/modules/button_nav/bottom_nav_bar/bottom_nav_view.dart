import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/app/constants/app_widget_size.dart';
import 'package:newshub/app/widget/item_widget.dart';
import 'package:newshub/app/widget/title_widget.dart';
import 'package:newshub/modules/button_nav/bottom_nav_bar/bottom_nav_controller.dart';
import 'package:newshub/modules/button_nav/widget/create_article_dialog.dart';
import 'package:newshub/modules/p1_home/home_view.dart';
import 'package:newshub/modules/p2_dashboard/dashboard_screen/dashboard_view.dart';
import 'package:newshub/modules/p3_search/search_view.dart';
import 'package:newshub/modules/p5_profile/view/profile_view.dart';

class BottomNavView extends StatelessWidget {
  BottomNavView({super.key});

  final controller = Get.put(BottomNavController());

  final screens = [
    HomeView(),
    DashboardView(),
    // // index 2 is FAB sheet, so leave as placeholder
    Text(""),
    SearchView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: screens[controller.currentIndex.value],
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.dialog(const CreateArticleDialog());
        },
        shape: const CircleBorder(),
        child: Icon(Icons.add, size: AppWidgetSize.iconSM, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(icon: Icons.home_outlined, label: "Home", index: 0),
              _navItem(
                  icon: Icons.dashboard_outlined, label: "Dash", index: 1),
              const SizedBox(width: 48),
              _navItem(
                  icon: Icons.search_outlined, label: "Search", index: 3),
              _navItem(
                  icon: Icons.person_outline, label: "Profile", index: 4),
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
        onTap: () {
          controller.changeTab(index);
        },
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
              ),
            ],
          ),
        ),
      );
    });
  }

  void _openPostSheet() {
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.paddingL),
            TitleWidget(title: "Create Content"),
            SizedBox(height: AppSpacing.paddingS),
            ItemWidget(
              icon: Icons.video_collection_outlined,
              title: "Video",
              onTap: () {
                print("Video tapped");
                Get.back(); // Close bottom sheet
                Get.snackbar("Info", "Video tapped");
              },
              onRightTap: () {},
            ),
            ItemWidget(
              icon: Icons.feed_outlined,
              title: "News Feed",
              onTap: () {
                print("News Feed tapped");
                Get.back();
                Get.snackbar("Info", "News Feed tapped");
              },
              onRightTap: () {},
            ),
            ItemWidget(
              icon: Icons.article_outlined,
              title: "Article",
              onTap: () {
                print("Article tapped");
                Get.back();
                Get.snackbar("Info", "Article tapped");
              },
              onRightTap: () {},
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
    );
  }
}