import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/app/theme/app_theme.dart';
import 'package:newshub/app/controllers/theme_controller.dart';
import 'package:newshub/app/controllers/language_controller.dart';
import 'package:newshub/modules/auth/services/auth_service.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'dart:convert';
// removed unused typed_data import
import 'dart:io';

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
    // Resolve avatar into ImageProvider: support base64, local files and network URLs
    String? avatar = userAvatar;
    ImageProvider? avatarProvider;

    if (avatar != null && avatar.isNotEmpty) {
      if (avatar.startsWith('data:image')) {
        try {
          final bytes = base64Decode(avatar.split(',').last);
          avatarProvider = MemoryImage(bytes);
        } catch (_) {
          avatarProvider = null;
        }
      } else {
        // Normalize file://
        String candidate = avatar;
        if (candidate.startsWith('file://')) candidate = candidate.replaceFirst('file://', '');

        try {
          final file = File(candidate);
          if (file.existsSync()) {
            avatarProvider = FileImage(file);
          }
        } catch (_) {
          avatarProvider = null;
        }

        if (avatarProvider == null) {
          // Treat as network/relative path
          String url = candidate;
          if (!url.startsWith('http://') && !url.startsWith('https://')) {
            url = '${AppConstants.STORAGE_BASE_URL}${candidate.startsWith('/') ? candidate : '/$candidate'}';
          }
          avatarProvider = NetworkImage(url);
        }
      }
    }

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
          GestureDetector(
            onTap: () {
              // Allow admin users to quickly change language by tapping avatar
              if (userRole.toLowerCase() == 'admin') {
                _showLanguageDialog(context);
              }
            },
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              backgroundImage: avatarProvider,
              child: avatarProvider == null
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
        return 'administrator'.tr;
      case 'organization':
        return 'organization'.tr;
      default:
        return 'organization'.tr;
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
    items.add(_buildSectionHeader('settings'.tr));
    // items.add(_buildMenuItem(
    //   icon: Icons.person,
    //   title: 'Profile',
    //   onTap: () => _navigateToProfile(context),
    // ));
    items.add(_buildMenuItem(
      icon: Icons.dark_mode,
      title: 'theme'.tr,
      subtitle: _getThemeText(),
      trailing: _buildThemeToggle(),
      onTap: () {},
    ));
    items.add(_buildMenuItem(
      icon: Icons.language,
      title: 'language'.tr,
      subtitle: _getLanguageText(),
      onTap: () => _showLanguageDialog(context),
    ));
    items.add(_buildMenuItem(
      icon: Icons.info_outline,
      title: 'about'.tr,
      onTap: () => _showAboutDialog(context),
    ));

    return items;
  }

  String _getThemeText() {
    final themeController = Get.find<ThemeController>();
    return themeController.themeMode.value == ThemeMode.dark ? 'dark_mode'.tr : 'light_mode'.tr;
  }

  String _getLanguageText() {
    final languageController = Get.find<LanguageController>();
    return languageController.isKhmer.value ? 'khmer'.tr : 'english'.tr;
  }

  List<Widget> _buildAdminMenu(BuildContext context) {
    return [
      _buildSectionHeader('admin_panel'.tr),
      _buildMenuItem(
        icon: Icons.dashboard,
        title: 'dashboard'.tr,
        onTap: () => Get.offAllNamed(Routes.ADMIN_BOTTOM_NAV),
      ),
      _buildMenuItem(
        icon: Icons.people,
        title: 'manage_users'.tr,
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ADMIN_MANAGE_USER);
        },
      ),
      _buildMenuItem(
        icon: Icons.article,
        title: 'manage_articles'.tr,
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ADMIN_MANAGE_ARTICLE);
        },
      ),
      _buildMenuItem(
        icon: Icons.category,
        title: 'manage_categories'.tr,
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ADMIN_MANAGE_CATEGORY);
        },
      ),
      _buildMenuItem(
        icon: Icons.bar_chart,
        title: 'reports_analytics'.tr,
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ADMIN_ANALYTICS);
        },
      ),
    ];
  }

  List<Widget> _buildOrganizationMenu(BuildContext context) {
    return [
      _buildSectionHeader('organization'.tr),
      _buildMenuItem(
        icon: Icons.home,
        title: 'home'.tr,
        onTap: () => Get.offAllNamed(Routes.ORG_BOTTOM_NAV),
      ),
      _buildMenuItem(
        icon: Icons.article,
        title: 'my_articles'.tr,
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ORG_MANAGE_ARTICLE);
        },
      ),
      _buildMenuItem(
        icon: Icons.group,
        title: 'team'.tr,
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ORG_TEAM);
        },
      ),
      _buildMenuItem(
        icon: Icons.analytics,
        title: 'reports'.tr,
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ORG_REPORT);
        },
      ),
      _buildMenuItem(
        icon: Icons.person,
        title: 'profile'.tr,
        onTap: () {
          Get.back();
          Get.toNamed(Routes.ORG_PROFILE);
        },
      ),
    ];
  }

  List<Widget> _buildUserMenu(BuildContext context) {
    return [
      _buildSectionHeader('menu'.tr),
      _buildMenuItem(
        icon: Icons.home,
        title: 'home'.tr,
        onTap: () => Get.offAllNamed(Routes.USER_BOTTOM_NAV),
      ),
      _buildMenuItem(
        icon: Icons.search,
        title: 'search'.tr,
        onTap: () {
          Get.back();
          Get.toNamed(Routes.USER_SEARCH);
        },
      ),
      _buildMenuItem(
        icon: Icons.bookmark,
        title: 'saved_articles'.tr,
        onTap: () {
          Get.back();
          Get.toNamed(Routes.USER_BOOKMARK);
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
    final themeController = Get.find<ThemeController>();
    return Obx(() {
      final isDark = themeController.themeMode.value == ThemeMode.dark;
      return Switch(
        value: isDark,
        onChanged: (value) {
          themeController.toggleTheme();
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'logout'.tr,
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
    Get.snackbar('settings'.tr, 'settings_coming_soon'.tr);
  }

  void _navigateToProfile(BuildContext context) {
    Get.back();
    // Navigate to profile based on role
    switch (userRole.toLowerCase()) {
      case 'admin':
        Get.snackbar('profile'.tr, 'admin_profile_coming_soon'.tr);
        break;
      case 'organization':
        Get.toNamed(Routes.ORG_PROFILE);
        break;
      default:
        Get.toNamed(Routes.USER_PROFILE);
    }
  }

  void _showLanguageDialog(BuildContext context) {
    Get.back();
    final languageController = Get.find<LanguageController>();
    Get.dialog(
      AlertDialog(
        title: Text('select_language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => ListTile(
              title: Text('english'.tr),
              leading: languageController.isKhmer.value 
                  ? null 
                  : const Icon(Icons.check, color: Colors.green),
              onTap: () {
                languageController.changeLanguage(false);
                Get.back();
              },
            )),
            Obx(() => ListTile(
              title: Text('khmer'.tr),
              leading: languageController.isKhmer.value 
                  ? const Icon(Icons.check, color: Colors.green) 
                  : null,
              onTap: () {
                languageController.changeLanguage(true);
                Get.back();
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
        ],
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
        title: Text('logout'.tr),
        content: Text('logout_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close dialog
              final authService = AuthService();
              await authService.logout();
              Get.offAllNamed(Routes.LOGIN);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('logout'.tr, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
