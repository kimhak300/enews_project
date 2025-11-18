import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/button_nav/bottom_nav_bar/bottom_nav_controller.dart';
import '../../../app/routes/app_pages.dart';
import '../../p1_home/home_controller.dart';

class BottomNavView extends GetView<HomeController> {
   BottomNavView({Key? key}) : super(key: key);

    final BottomNavController bottomNavController = Get.put(BottomNavController());

  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          onTap: (index) {
            if (index == 2) {
              _showPostSheet(context);
              return;
            }
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
              icon: const Icon(Icons.post_add_outlined),
              activeIcon: const Icon(Icons.post_add),
              label: 'post'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search_outlined),
              activeIcon: const Icon(Icons.search),
              label: 'search'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: 'profile'.tr,
            ),
          ],
        ));
  }

  void _showPostSheet(BuildContext context) {
    final theme = Theme.of(context);
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: BoxDecoration(
            color: theme.bottomSheetTheme.backgroundColor ?? theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: Get.back,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'post'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 8),
              _buildPostOption(
                context: context,
                icon: Icons.play_circle_fill,
                color: const Color(0xFF0785FF),
                label: 'video'.tr,
                onTap: () {
                  Get.back();
                  Get.snackbar('video'.tr, 'coming_soon'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2));
                },
              ),
              _buildPostOption(
                context: context,
                icon: Icons.send,
                color: const Color(0xFFFF7A18),
                label: 'news_feed'.tr,
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.EDIT_POST);
                },
              ),
              _buildPostOption(
                context: context,
                icon: Icons.article_outlined,
                color: const Color(0xFFFFB703),
                label: 'article'.tr,
                onTap: () {
                  Get.back();
                  Get.snackbar('article'.tr, 'coming_soon'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2));
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildPostOption({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right,
            color: theme.iconTheme.color?.withOpacity(0.4) ?? Colors.grey),
      ),
    );
  }
}
