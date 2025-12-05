import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/app/services/storage_service.dart';
import 'package:newshub/app/theme/app_theme.dart';

class AppDrawerWidget extends StatelessWidget {
  final String userRole;
  final String userName;
  final String userEmail;
  final String? userAvatar;

  const AppDrawerWidget({
    super.key,
    required this.userRole,
    required this.userName,
    required this.userEmail,
    this.userAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _buildMenuItems(context),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final hasAvatar = userAvatar != null && userAvatar!.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 20,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            backgroundImage: hasAvatar ? NetworkImage(userAvatar!) : null,
            child: !hasAvatar
                ? Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getRoleDisplayName(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleDisplayName() {
    switch (userRole.toLowerCase()) {
      case 'admin':
        return 'Administrator';
      case 'organization':
        return 'Organization';
      default:
        return 'User';
    }
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    List<Widget> items = [];

    // Common header
    items.add(const SizedBox(height: 8));

    // Role-specific menu items
    switch (userRole.toLowerCase()) {
      case 'admin':
        items.addAll(_buildAdminMenu(context));
        break;
      case 'organization':
        items.addAll(_buildOrganizationMenu(context));
        break;
      default:
        items.addAll(_buildUserMenu(context));
    }

    // Common settings section
    items.add(const Divider(height: 32));
    items.add(_buildSectionHeader('Settings'));
    items.add(_buildMenuItem(
      icon: Icons.settings,
      title: 'Settings',
      onTap: () => _navigateToSettings(context),
    ));
    items.add(_buildMenuItem(
      icon: Icons.dark_mode,
      title: 'Theme',
      trailing: _buildThemeToggle(),
      onTap: () {},
    ));
    items.add(_buildMenuItem(
      icon: Icons.language,
      title: 'Language',
      subtitle: 'English',
      onTap: () => _showLanguageDialog(context),
    ));
    items.add(_buildMenuItem(
      icon: Icons.info_outline,
      title: 'About',
      onTap: () => _showAboutDialog(context),
    ));

    return items;
  }

  List<Widget> _buildAdminMenu(BuildContext context) {
    return [
      _buildSectionHeader('Admin Panel'),
      _buildMenuItem(
        icon: Icons.dashboard,
        title: 'Dashboard',
        onTap: () => Get.offAllNamed(Routes.ADMIN_BOTTOM_NAV),
      ),
      _buildMenuItem(
        icon: Icons.people,
        title: 'Manage Users',
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ADMIN_MANAGE_USER);
        },
      ),
      _buildMenuItem(
        icon: Icons.article,
        title: 'Manage Articles',
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ADMIN_MANAGE_ARTICLE);
        },
      ),
      _buildMenuItem(
        icon: Icons.category,
        title: 'Manage Categories',
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ADMIN_MANAGE_CATEGORY);
        },
      ),
      _buildMenuItem(
        icon: Icons.bar_chart,
        title: 'Reports & Analytics',
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ADMIN_ANALYTICS);
        },
      ),
    ];
  }

  List<Widget> _buildOrganizationMenu(BuildContext context) {
    return [
      _buildSectionHeader('Organization'),
      _buildMenuItem(
        icon: Icons.home,
        title: 'Home',
        onTap: () => Get.offAllNamed(Routes.ORG_BOTTOM_NAV),
      ),
      _buildMenuItem(
        icon: Icons.article,
        title: 'My Articles',
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ORG_MANAGE_ARTICLE);
        },
      ),
      _buildMenuItem(
        icon: Icons.group,
        title: 'Team',
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ORG_TEAM);
        },
      ),
      _buildMenuItem(
        icon: Icons.analytics,
        title: 'Reports',
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ORG_REPORT);
        },
      ),
      _buildMenuItem(
        icon: Icons.person,
        title: 'Profile',
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ORG_PROFILE);
        },
      ),
    ];
  }

  List<Widget> _buildUserMenu(BuildContext context) {
    return [
      _buildSectionHeader('Menu'),
      _buildMenuItem(
        icon: Icons.home,
        title: 'Home',
        onTap: () => Get.offAllNamed(Routes.USER_BOTTOM_NAV),
      ),
      _buildMenuItem(
        icon: Icons.search,
        title: 'Search',
        onTap: () {
          Get.back();
          Get.toNamed(Routes.USER_SEARCH);
        },
      ),
      _buildMenuItem(
        icon: Icons.bookmark,
        title: 'Saved Articles',
        onTap: () {
          Get.back();
          Get.toNamed(Routes.USER_BOOKMARK);
        },
      ),
      _buildMenuItem(
        icon: Icons.person,
        title: 'Profile',
        onTap: () {
          Get.back();
          Get.toNamed(Routes.USER_PROFILE);
        },
      ),
    ];
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildThemeToggle() {
    return Obx(() {
      final isDark = Get.isDarkMode;
      return Switch(
        value: isDark,
        onChanged: (value) {
          Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
          final storage = Get.find<StorageService>();
          storage.write('isDarkMode', value);
        },
        activeColor: AppTheme.primaryColor,
      );
    });
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: SafeArea(
        top: false,
        child: InkWell(
          onTap: () => _logout(context),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Get.back();
    // Navigate to settings page
    Get.snackbar('Settings', 'Settings page coming soon');
  }

  void _showLanguageDialog(BuildContext context) {
    Get.back();
    Get.dialog(
      AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: const Icon(Icons.check),
              onTap: () {
                Get.back();
                Get.updateLocale(const Locale('en', 'US'));
              },
            ),
            ListTile(
              title: const Text('ភាសាខ្មែរ'),
              onTap: () {
                Get.back();
                Get.updateLocale(const Locale('km', 'KH'));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    Get.back();
    showAboutDialog(
      context: context,
      applicationName: 'ENews',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 ENews. All rights reserved.',
      children: [
        const SizedBox(height: 16),
        const Text('A modern news application for Cambodia'),
      ],
    );
  }

  void _logout(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final storage = Get.find<StorageService>();
              await storage.removeData('token');
              await storage.removeData('user');
              Get.offAllNamed(Routes.LOGIN);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
