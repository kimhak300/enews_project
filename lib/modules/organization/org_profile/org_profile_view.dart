import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/theme/app_theme.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/auth/services/auth_service.dart';
import 'package:newshub/app/controllers/theme_controller.dart';
import 'package:newshub/app/controllers/language_controller.dart';

class OrgProfileView extends StatelessWidget {
  const OrgProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Profile'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.business,
                      size: 50,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Organization Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'organizer@enews.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'ORGANIZER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Organization Section
            _buildSectionTitle('Organization'),
            _buildMenuItem(
              icon: Icons.business_outlined,
              title: 'Organization Info',
              onTap: () {
                Get.snackbar('Coming Soon', 'Organization info feature coming soon');
              },
            ),
            _buildMenuItem(
              icon: Icons.group_outlined,
              title: 'Team Members',
              onTap: () {
                Get.toNamed(Routes.ORG_TEAM);
              },
            ),
            _buildMenuItem(
              icon: Icons.article_outlined,
              title: 'My Articles',
              onTap: () {
                Get.toNamed(Routes.ORG_MANAGE_ARTICLE);
              },
            ),
            _buildMenuItem(
              icon: Icons.analytics_outlined,
              title: 'Reports',
              onTap: () {
                Get.toNamed(Routes.ORG_REPORT);
              },
            ),
            
            const SizedBox(height: 16),
            
            // Settings Section
            _buildSectionTitle('Settings'),
            _buildMenuItem(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () {
                Get.snackbar('Coming Soon', 'Edit profile feature coming soon');
              },
            ),
            _buildMenuItem(
              icon: Icons.dark_mode_outlined,
              title: 'Theme',
              subtitle: Obx(() => Text(
                themeController.themeMode.value == ThemeMode.dark 
                    ? 'Dark Mode' 
                    : 'Light Mode'
              )),
              trailing: Obx(() => Switch(
                value: themeController.themeMode.value == ThemeMode.dark,
                onChanged: (value) {
                  themeController.toggleTheme();
                },
                activeColor: AppTheme.primaryColor,
              )),
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: Obx(() => Text(
                languageController.isKhmer.value ? 'ភាសាខ្មែរ' : 'English'
              )),
              onTap: () => _showLanguageDialog(languageController),
            ),
            
            const SizedBox(height: 16),
            
            // Account Section
            _buildSectionTitle('Account'),
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {
                Get.snackbar('Coming Soon', 'Notifications feature coming soon');
              },
            ),
            _buildMenuItem(
              icon: Icons.lock_outline,
              title: 'Privacy & Security',
              onTap: () {
                Get.snackbar('Coming Soon', 'Privacy settings coming soon');
              },
            ),
            
            const SizedBox(height: 16),
            
            // About Section
            _buildSectionTitle('About'),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About App',
              onTap: () => _showAboutDialog(context),
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Get.snackbar('Coming Soon', 'Help & Support coming soon');
              },
            ),
            
            const SizedBox(height: 24),
            
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: Text(
                    'logout'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
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
    Widget? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
  
  void _showLanguageDialog(LanguageController languageController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => ListTile(
              title: const Text('English'),
              leading: languageController.isKhmer.value 
                  ? null 
                  : const Icon(Icons.check, color: Colors.green),
              onTap: () {
                languageController.changeLanguage(false);
                Get.back();
              },
            )),
            Obx(() => ListTile(
              title: const Text('ភាសាខ្មែរ (Khmer)'),
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
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'ENews',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 ENews. All rights reserved.',
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
              
              // Show loading
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(),
                ),
                barrierDismissible: false,
              );
              
              // Logout
              final authService = AuthService();
              await authService.logout();
              
              // Close loading
              Get.back();
              
              // Navigate to login
              Get.offAllNamed(Routes.LOGIN);
              
              // Show success message
              Get.snackbar(
                'logged_out'.tr,
                'logged_out_message'.tr,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }
}
