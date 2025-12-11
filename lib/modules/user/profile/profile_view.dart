import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/theme/app_theme.dart';
import 'package:newshub/app/routes/app_routes.dart';
import 'package:newshub/modules/auth/services/auth_service.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'dart:convert';
import 'dart:io';
import 'package:newshub/modules/user/profile/profile_controller.dart';
import 'package:newshub/app/controllers/theme_controller.dart';
import 'package:newshub/app/controllers/language_controller.dart';
import 'package:newshub/app/services/storage_service.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
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
              child: Builder(
                builder: (context) {
                  final profileCtrl = Get.find<ProfileController>();
                  return Obx(() {
                    // compute avatar provider from controller state
                    ImageProvider? avatarProvider;
                    final picked = profileCtrl.profileImage.value;
                    final avatarPath = profileCtrl.avatarPath.value;
                    if (picked != null) {
                      avatarProvider = FileImage(picked);
                    } else if (avatarPath != null && avatarPath.isNotEmpty) {
                      if (avatarPath.startsWith('data:image')) {
                        try {
                          final bytes = base64Decode(avatarPath.split(',').last);
                          avatarProvider = MemoryImage(bytes);
                        } catch (_) {
                          avatarProvider = null;
                        }
                      } else {
                        String candidate = avatarPath;
                        if (candidate.startsWith('file://')) candidate = candidate.replaceFirst('file://', '');
                        try {
                          final file = File(candidate);
                          if (file.existsSync()) avatarProvider = FileImage(file);
                        } catch (_) {
                          avatarProvider = null;
                        }
                        if (avatarProvider == null) {
                          String url = candidate;
                          if (!url.startsWith('http://') && !url.startsWith('https://')) {
                            url = '${AppConstants.STORAGE_BASE_URL}${candidate.startsWith('/') ? candidate : '/$candidate'}';
                          }
                          avatarProvider = NetworkImage(url);
                        }
                      }
                    }

                    String roleDisplay() {
                      // role is not stored in controller; default to User
                      return 'User';
                    }

                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: avatarProvider,
                          child: avatarProvider == null
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppTheme.primaryColor,
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profileCtrl.userName.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profileCtrl.userEmail.value,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            roleDisplay(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  });
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Settings Section
            // Settings Section
            _buildSectionTitle('settings'.tr),
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'edit_profile'.tr,
              onTap: () async {
                final authService = AuthService();
                final user = await authService.getSavedUser();
                final role = user?.primaryRole ?? 'user';
                if (role.toLowerCase() != 'user') {
                  Get.snackbar('error'.tr, 'only_regular_users_can_edit_profile'.tr, snackPosition: SnackPosition.BOTTOM);
                  return;
                }

                final profileCtrl = Get.find<ProfileController>();
                final nameCtrl = TextEditingController(text: user?.name ?? '');
                final emailCtrl = TextEditingController(text: user?.email ?? '');

                await Get.dialog(AlertDialog(
                    title: Text('edit_profile'.tr),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        // Avatar picker button (uses ProfileController)
                      OutlinedButton.icon(
                        onPressed: () => profileCtrl.showImageSourceDialog(),
                        icon: const Icon(Icons.photo_camera),
                        label: Text('choose_avatar'.tr),
                      ),
                      const SizedBox(height: 8),
                      TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'name'.tr)),
                      TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'email'.tr)),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
                    ElevatedButton(
                      onPressed: () async {
                        // Persist changes to storage and avatar path if picked
                        final storage = StorageService.to;
                        final raw = storage.read<String>(AppConstants.USER_INFO_KEY);
                        if (raw != null) {
                          try {
                            final Map<String, dynamic> map = jsonDecode(raw) as Map<String, dynamic>;
                            map['display_name'] = nameCtrl.text;
                            map['full_name'] = nameCtrl.text;
                            map['name'] = nameCtrl.text;
                            map['email'] = emailCtrl.text;

                            // If user picked an image, save its local path
                            final picked = profileCtrl.profileImage.value;
                            if (picked != null) {
                              // store as local file path
                              map['avatar_url'] = picked.path;
                            }

                            await storage.write(AppConstants.USER_INFO_KEY, jsonEncode(map));

                            // Update reactive controller so profile view refreshes in-place
                            final profile = Get.find<ProfileController>();
                            profile.userName.value = nameCtrl.text;
                            profile.userEmail.value = emailCtrl.text;
                            if (picked != null) {
                              profile.avatarPath.value = picked.path;
                            }

                            Get.back();
                            Get.snackbar('success'.tr, 'profile_updated'.tr, snackPosition: SnackPosition.BOTTOM);
                          } catch (e) {
                            Get.snackbar('error'.tr, 'failed_to_save_profile'.tr);
                          }
                        } else {
                          Get.snackbar('Error', 'No user session found');
                        }
                      },
                      child:  Text('save'.tr),
                    ),
                  ],
                ));
              },
            ),
            _buildMenuItem(
              icon: Icons.dark_mode_outlined,
              title: 'theme'.tr,
              subtitle: Obx(() => Text(
                themeController.themeMode.value == ThemeMode.dark 
                    ? 'dark_mode'.tr 
                    : 'light_mode'.tr
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
              title: 'language'.tr,
              subtitle: Obx(() => Text(
                languageController.isKhmer.value ? 'khmer'.tr : 'english'.tr
              )),
              onTap: () => _showLanguageDialog(languageController),
            ),
            
            const SizedBox(height: 16),
            
            // Account Section
            _buildSectionTitle('account'.tr),
            _buildMenuItem(
              icon: Icons.bookmark_outline,
              title: 'saved'.tr,
              onTap: () {
                Get.toNamed(Routes.USER_BOOKMARK);
              },
            ),
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'notifications'.tr,
              onTap: () {
                Get.snackbar('Coming Soon', 'Notifications feature coming soon');
              },
            ),
            _buildMenuItem(
              icon: Icons.lock_outline,
              title: 'privacy_settings'.tr,
              onTap: () {
                Get.snackbar('coming_soon'.tr, 'privacy_settings_coming_soon'.tr);
              },
            ),
            
            const SizedBox(height: 16),
            
            // About Section
            _buildSectionTitle('about'.tr),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'about_app'.tr,
              onTap: () => _showAboutDialog(context),
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'help_support'.tr,
              onTap: () {
                Get.snackbar('coming_soon'.tr, 'help_support_coming_soon'.tr);
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
            child: Text('close'.tr),
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
