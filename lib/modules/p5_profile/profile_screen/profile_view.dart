import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put to ensure controller exists when accessed from bottom nav
    final ctrl = Get.put(ProfileController());
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        color: theme.colorScheme.background,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(8)),
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
                              radius: 54,
                              backgroundColor: theme.colorScheme.primary,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: theme.colorScheme.onPrimary,
                                backgroundImage: ctrl.profileImage.value != null
                                    ? FileImage(ctrl.profileImage.value!)
                                    : null,
                                child: ctrl.profileImage.value == null
                                    ? Icon(
                                        Icons.person,
                                        size: 56,
                                        color: theme.colorScheme.primary,
                                      )
                                    : null,
                              ),
                            ),
                          )),
                      Obx(() => ctrl.isEditing.value
                          ? Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.background,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          : const SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Obx(() => ctrl.isEditing.value
                      ? Column(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: ctrl.nameController,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      theme.colorScheme.onSurface.withOpacity(0.8),
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                    color: theme.colorScheme.primary,
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.primary,
                                    ),

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
                                  color:
                                      theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    color: theme.colorScheme.primary,
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.4),
                                    ),
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
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: ctrl.cancelEditing,
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: ctrl.saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        theme.colorScheme.background,
                                    foregroundColor: Theme.of(context).colorScheme.primary,
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
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            // const SizedBox(height: 4),
                            Text(
                              ctrl.userEmail.value,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        )),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                children: [
                  _buildSectionTitle('Account Settings'.tr, theme),
                  _buildMenuItem(
                    icon: Icons.edit,
                    title: 'edit_profile'.tr,
                    onTap: ctrl.enableEditing,
                    theme: theme,
                  ),
                  _buildMenuItem(
                    icon: Icons.bookmark,
                    title: 'my_bookmarks'.tr,
                    onTap: ctrl.goToBookmarks,
                    theme: theme,
                  ),
                  // const SizedBox(height: 8),
                  _buildSectionTitle('App Preferences'.tr, theme),
                  _buildMenuItem(
                    icon: Icons.notifications,
                    title: 'notification'.tr,
                    onTap: ctrl.goToNotifications,
                    theme: theme,
                  ),
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: 'setting'.tr,
                    onTap: ctrl.goToSettings,
                    theme: theme,
                  ),
                  // const SizedBox(height: 8),
                  _buildSectionTitle('Help & Support'.tr, theme),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'about_help'.tr,
                    onTap: ctrl.goToAbout,
                    theme: theme,
                  ),
                  // const SizedBox(height: 8),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'logout'.tr,
                    onTap: ctrl.logout,
                    iconColor: theme.colorScheme.error,
                    textColor: theme.colorScheme.error,
                    backgroundColor:
                        theme.colorScheme.errorContainer.withOpacity(0.3),
                    showArrow: false,
                    theme: theme,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    Color? backgroundColor,
    bool showArrow = true,
    ThemeData? theme,
  }) {

    final resolvedTheme = theme ?? Theme.of(Get.context!);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? resolvedTheme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: resolvedTheme.shadowColor.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? resolvedTheme.colorScheme.primary)
                .withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: iconColor ?? resolvedTheme.colorScheme.primary, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor ?? resolvedTheme.colorScheme.onSurface,
          ),
        ),
        trailing: showArrow
            ? Icon(Icons.chevron_right,
                color: resolvedTheme.iconTheme.color?.withOpacity(0.6))
            : null,
        onTap: onTap,
      ),
    );
  }
}
