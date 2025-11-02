// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put to ensure controller exists when accessed from bottom nav
    final ctrl = Get.put(ProfileController());

    return SafeArea(
      child: Column(
        children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Obx(() => GestureDetector(
                            onTap: ctrl.isEditing.value
                                ? ctrl.showImageSourceDialog
                                : null,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: ctrl.profileImage.value != null
                                  ? FileImage(ctrl.profileImage.value!)
                                  : null,
                              child: ctrl.profileImage.value == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppTheme.primaryColor,
                                    )
                                  : null,
                            ),
                          )),
                      Obx(() => ctrl.isEditing.value
                          ? Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            )
                          : const SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() => ctrl.isEditing.value
                      ? Column(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: ctrl.nameController,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(color: Colors.blue),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),

                                  ),
                                  // enabledBorder: UnderlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.blue),
                                  // ),
                                  // focusedBorder: UnderlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.blue),
                                  // ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 250,
                              child: TextField(
                                controller: ctrl.emailController,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.blue),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white60),
                                  ),
                                  // enabledBorder: UnderlineInputBorder(
                                  //   borderSide:
                                  //       BorderSide(color: Colors.white60),
                                  // ),
                                  // focusedBorder: UnderlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.white),
                                  // ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: ctrl.cancelEditing,
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: ctrl.saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppTheme.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 8),
                                  ),
                                  child: Text('save'.tr),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              ctrl.userName.value,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ctrl.userEmail.value,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        )),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildMenuItem(
                    icon: Icons.edit,
                    title: 'edit_profile'.tr,
                    onTap: ctrl.enableEditing,
                  ),
                  _buildMenuItem(
                    icon: Icons.bookmark,
                    title: 'my_bookmarks'.tr,
                    onTap: ctrl.goToBookmarks,
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications,
                    title: 'notification'.tr,
                    onTap: ctrl.goToNotifications,
                  ),
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: 'setting'.tr,
                    onTap: ctrl.goToSettings,
                  ),
                  _buildMenuItem(
                    icon: Icons.info,
                    title: 'about_help'.tr,
                    onTap: ctrl.goToAbout,
                  ),
                  const SizedBox(height: 16),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'logout'.tr,
                    onTap: ctrl.logout,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {

    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppTheme.primaryColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
