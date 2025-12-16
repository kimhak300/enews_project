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
            // Profile Header (compact rounded card)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
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
                          final bytes =
                              base64Decode(avatarPath.split(',').last);
                          avatarProvider = MemoryImage(bytes);
                        } catch (_) {
                          avatarProvider = null;
                        }
                      } else {
                        String candidate = avatarPath;
                        if (candidate.startsWith('file://'))
                          candidate = candidate.replaceFirst('file://', '');
                        try {
                          final file = File(candidate);
                          if (file.existsSync())
                            avatarProvider = FileImage(file);
                        } catch (_) {
                          avatarProvider = null;
                        }
                        if (avatarProvider == null) {
                          String url = candidate;
                          if (!url.startsWith('http://') &&
                              !url.startsWith('https://')) {
                            url =
                                '${AppConstants.STORAGE_BASE_URL}${candidate.startsWith('/') ? candidate : '/$candidate'}';
                          }
                          avatarProvider = NetworkImage(url);
                        }
                      }
                    }

                    String roleDisplay() {
                      final role = profileCtrl.userRole.value.toLowerCase();
                      switch (role) {
                        case 'admin':
                          return 'administrator'.tr;
                        case 'organization':
                        case 'organizer':
                          return 'organization'.tr;
                        default:
                          return 'user'.tr;
                      }
                    }

                    return Column(
                      children: [
                        // Avatar with white ring and shadow
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 44,
                            backgroundColor: AppTheme.primaryColor,
                            backgroundImage: avatarProvider,
                            child: avatarProvider == null
                                ? Icon(
                                    Icons.person,
                                    size: 44,
                                    color: AppTheme.primaryColor,
                                  )
                                : null,
                          ),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
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
                // Allow regular users, organization and admin to edit their profile
                final authService = Get.find<AuthService>();
                final user = await authService.getSavedUser();

                final profileCtrl = Get.find<ProfileController>();
                final nameCtrl = TextEditingController(text: user?.name ?? '');
                final emailCtrl =
                    TextEditingController(text: user?.email ?? '');

                await Get.dialog(Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          'edit_profile'.tr,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Avatar picker button
                        OutlinedButton.icon(
                          onPressed: () => profileCtrl.showImageSourceDialog(),
                          icon: const Icon(Icons.photo_camera),
                          label: Text('choose_avatar'.tr),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            side: BorderSide(
                              color: AppTheme.primaryColor.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Name field
                        TextField(
                          controller: nameCtrl,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'name'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color:  AppTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Email field
                        TextField(
                          controller: emailCtrl,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'email'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color:  AppTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'cancel'.tr,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () async {
                        try {
                          print('=== SAVE BUTTON CLICKED ===');
                          print('Name: ${nameCtrl.text}');
                          print('Email: ${emailCtrl.text}');
                          print(
                              'Avatar path: ${profileCtrl.profileImage.value?.path}');

                          // Show loading
                          Get.dialog(
                            const Center(child: CircularProgressIndicator()),
                            barrierDismissible: false,
                          );

                          // Save to backend API first - use Get.find instead of creating new instance
                          final authService = Get.find<AuthService>();

                          // Only send changed values
                          final currentUser = await authService.getSavedUser();
                          final success = await authService.updateProfile(
                            displayName: nameCtrl.text != currentUser?.name
                                ? nameCtrl.text
                                : null,
                            email: emailCtrl.text != currentUser?.email
                                ? emailCtrl.text
                                : null,
                            avatarPath: profileCtrl.profileImage.value?.path,
                          );

                          print('=== UPDATE RESULT: $success ===');

                          // Close loading dialog
                          Get.back();

                          if (success) {
                            // Update reactive controller so profile view refreshes in-place
                            final profile = Get.find<ProfileController>();
                            profile.userName.value = nameCtrl.text;
                            profile.userEmail.value = emailCtrl.text;
                            final picked = profileCtrl.profileImage.value;
                            if (picked != null) {
                              profile.avatarPath.value = picked.path;
                            }

                            Get.back();
                            Get.snackbar(
                              'success'.tr,
                              'profile_updated'.tr,
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } else {
                            Get.snackbar(
                              'error'.tr,
                              'failed_to_save_profile'.tr,
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } catch (e) {
                          // Close loading if still open
                          if (Get.isDialogOpen == true) {
                            Get.back();
                          }

                          Get.snackbar(
                            'error'.tr,
                            'Error: ${e.toString()}',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 5),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'save'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
              },
            ),
            _buildMenuItem(
              icon: Icons.dark_mode_outlined,
              title: 'theme'.tr,
              subtitle: Obx(() => Text(
                  themeController.themeMode.value == ThemeMode.dark
                      ? 'dark_mode'.tr
                      : 'light_mode'.tr)),
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
              subtitle: Obx(() => Text(languageController.isKhmer.value
                  ? 'khmer'.tr
                  : 'english'.tr)),
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
            // _buildMenuItem(
            //   icon: Icons.notifications_outlined,
            //   title: 'notifications'.tr,
            //   onTap: () {
            //     Get.snackbar(
            //         'Coming Soon', 'Notifications feature coming soon');
            //   },
            // ),
            _buildMenuItem(
              icon: Icons.lock_outline,
              title: 'privacy_settings'.tr,
              onTap: () {
                Get.toNamed(Routes.PRIVACY_SETTINGS);
              },
            ),

            const SizedBox(height: 16),

            // About Section
            _buildSectionTitle('about'.tr),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'about_app'.tr,
              onTap: () {
                Get.toNamed(Routes.ABOUT_APP);
              },
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'help_support'.tr,
              onTap: () {
                Get.toNamed(Routes.HELP_SUPPORT);
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
              final authService = Get.find<AuthService>();
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
