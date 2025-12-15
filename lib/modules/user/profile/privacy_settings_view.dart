import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'privacy_settings_controller.dart';

class PrivacySettingsView extends GetView<PrivacySettingsController> {
  const PrivacySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('privacy_settings'.tr),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Visibility Section
            _buildSectionHeader(
              context,
              icon: Icons.visibility_outlined,
              title: 'profile_visibility'.tr,
            ),
            Obx(() => _buildSwitchTile(
                  context: context,
                  title: 'show_profile_picture'.tr,
                  subtitle: 'others_can_see_profile_picture'.tr,
                  value: controller.showProfilePicture.value,
                  onChanged: controller.toggleShowProfilePicture,
                )),
            Obx(() => _buildSwitchTile(
                  context: context,
                  title: 'show_email'.tr,
                  subtitle: 'display_email_on_profile'.tr,
                  value: controller.showEmail.value,
                  onChanged: controller.toggleShowEmail,
                )),
            Obx(() => _buildSwitchTile(
                  context: context,
                  title: 'show_phone'.tr,
                  subtitle: 'display_phone_on_profile'.tr,
                  value: controller.showPhone.value,
                  onChanged: controller.toggleShowPhone,
                )),

            Divider(height: 32.h, thickness: 8, color: theme.colorScheme.surfaceVariant),

            // Interactions Section
            _buildSectionHeader(
              context,
              icon: Icons.people_outline,
              title: 'interactions'.tr,
            ),
            // Obx(() => _buildSwitchTile(
            //       context: context,
            //       title: 'allow_tagging'.tr,
            //       subtitle: 'others_can_tag_you'.tr,
            //       value: controller.allowTagging.value,
            //       onChanged: controller.toggleAllowTagging,
            //     )),
            Obx(() => _buildSwitchTile(
                  context: context,
                  title: 'show_online_status'.tr,
                  subtitle: 'show_when_active'.tr,
                  value: controller.showOnlineStatus.value,
                  onChanged: controller.toggleShowOnlineStatus,
                )),
            // Obx(() => _buildSwitchTile(
            //       context: context,
            //       title: 'allow_messaging'.tr,
            //       subtitle: 'receive_messages_from_others'.tr,
            //       value: controller.allowMessaging.value,
            //       onChanged: controller.toggleAllowMessaging,
            //     )),

            // Divider(height: 32.h, thickness: 8, color: theme.colorScheme.surfaceVariant),

            // Notifications Section
            // _buildSectionHeader(
            //   context,
            //   icon: Icons.notifications_outlined,
            //   title: 'notification_preferences'.tr,
            // ),
            // Obx(() => _buildSwitchTile(
            //       context: context,
            //       title: 'push_notifications'.tr,
            //       subtitle: 'receive_push_notifications'.tr,
            //       value: controller.pushNotifications.value,
            //       onChanged: controller.togglePushNotifications,
            //     )),
            // Obx(() => _buildSwitchTile(
            //       context: context,
            //       title: 'email_notifications'.tr,
            //       subtitle: 'receive_email_updates'.tr,
            //       value: controller.emailNotifications.value,
            //       onChanged: controller.toggleEmailNotifications,
            //     )),

            Divider(height: 32.h, thickness: 8, color: theme.colorScheme.surfaceVariant),

            // Data & Privacy Section
            _buildSectionHeader(
              context,
              icon: Icons.security_outlined,
              title: 'data_privacy'.tr,
            ),
            Obx(() => _buildSwitchTile(
                  context: context,
                  title: 'data_collection'.tr,
                  subtitle: 'allow_analytics_data_collection'.tr,
                  value: controller.dataCollection.value,
                  onChanged: controller.toggleDataCollection,
                )),
            Obx(() => _buildSwitchTile(
                  context: context,
                  title: 'personalization'.tr,
                  subtitle: 'personalized_content_recommendations'.tr,
                  value: controller.personalization.value,
                  onChanged: controller.togglePersonalization,
                )),

            SizedBox(height: 16.h),

            // Additional Options
            _buildListTile(
              context: context,
              icon: Icons.lock_outline,
              title: 'change_password'.tr,
              onTap: () => _showChangePasswordDialog(context),
            ),
            _buildListTile(
              context: context,
              icon: Icons.delete_outline,
              title: 'delete_account'.tr,
              titleColor: theme.colorScheme.error,
              onTap: () {
                _showDeleteAccountDialog(context);
              },
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required IconData icon, required String title}) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final theme = Theme.of(context);
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13.sp,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: theme.colorScheme.primary,
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: titleColor ?? theme.colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: titleColor ?? theme.colorScheme.onSurface,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final theme = Theme.of(context);
    final passwordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('delete_account'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'delete_account_warning'.tr,
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'password'.tr,
                hintText: 'enter_password_to_confirm'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        if (passwordController.text.trim().isEmpty) {
                          Get.snackbar(
                            'error'.tr,
                            'please_enter_password'.tr,
                          );
                          return;
                        }
                        controller.deleteAccount(
                          password: passwordController.text.trim(),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onError,
                        ),
                      )
                    : Text('delete'.tr),
              )),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final theme = Theme.of(context);
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final showCurrentPassword = false.obs;
    final showNewPassword = false.obs;
    final showConfirmPassword = false.obs;

    Get.dialog(
      AlertDialog(
        title: Text('change_password'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => TextField(
                    controller: currentPasswordController,
                    obscureText: !showCurrentPassword.value,
                    decoration: InputDecoration(
                      labelText: 'current_password'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showCurrentPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            showCurrentPassword.value = !showCurrentPassword.value,
                      ),
                    ),
                  )),
              SizedBox(height: 16.h),
              Obx(() => TextField(
                    controller: newPasswordController,
                    obscureText: !showNewPassword.value,
                    decoration: InputDecoration(
                      labelText: 'new_password'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showNewPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            showNewPassword.value = !showNewPassword.value,
                      ),
                    ),
                  )),
              SizedBox(height: 16.h),
              Obx(() => TextField(
                    controller: confirmPasswordController,
                    obscureText: !showConfirmPassword.value,
                    decoration: InputDecoration(
                      labelText: 'confirm_new_password'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showConfirmPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            showConfirmPassword.value = !showConfirmPassword.value,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        final current = currentPasswordController.text.trim();
                        final newPass = newPasswordController.text.trim();
                        final confirm = confirmPasswordController.text.trim();

                        if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                          Get.snackbar(
                            'error'.tr,
                            'all_fields_required'.tr,
                          );
                          return;
                        }

                        if (newPass.length < 6) {
                          Get.snackbar(
                            'error'.tr,
                            'password_min_length'.tr,
                          );
                          return;
                        }

                        if (newPass != confirm) {
                          Get.snackbar(
                            'error'.tr,
                            'passwords_do_not_match'.tr,
                          );
                          return;
                        }

                        controller.changePassword(
                          currentPassword: current,
                          newPassword: newPass,
                          newPasswordConfirmation: confirm,
                        );
                      },
                child: controller.isLoading.value
                    ? SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text('change_password'.tr),
              )),
        ],
      ),
    );
  }
}
