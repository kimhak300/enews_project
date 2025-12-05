import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/settings_controller.dart';
// import '../../../core/controllers/language_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'preferences'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                Obx(
                  () => SwitchListTile(
                    title: Text('push_notifications'.tr),
                    subtitle: Text('receive_breaking_news'.tr),
                    value: controller.pushNotifications.value,
                    onChanged: controller.togglePushNotifications,
                  ),
                ),
                const Divider(height: 1),
                Obx(
                  () => SwitchListTile(
                    title: Text('email_notifications'.tr),
                    subtitle: Text('daily_news_digest'.tr),
                    value: controller.emailNotifications.value,
                    onChanged: controller.toggleEmailNotifications,
                  ),
                ),
                const Divider(height: 1),
                // Obx(
                //   () => SwitchListTile(
                //     title: Text('dark_mode'.tr),
                //     subtitle: Text('enable_dark_theme'.tr),
                //     value: controller.darkMode.value,
                //     onChanged: controller.toggleDarkMode,
                //   ),
                // ),
                // const Divider(height: 1),
                // GetX<LanguageController>(
                //   builder: (languageController) => SwitchListTile(
                //     title: Text('select_language'.tr),
                //     subtitle: Text(
                //       languageController.isKhmer.value
                //           ? 'khmer'.tr
                //           : 'english'.tr,
                //     ),
                //     value: languageController.isKhmer.value,
                //     onChanged: (value) =>
                //         languageController.changeLanguage(value),
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'account'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('change_password'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.snackbar(
                      'feature'.tr,
                      'change_password_coming_soon'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text('privacy_settings'.tr),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.snackbar(
                      'feature'.tr,
                      'privacy_settings_coming_soon'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    'delete_account'.tr,
                    style: const TextStyle(color: Colors.red),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.red),
                  onTap: () {
                    Get.defaultDialog(
                      title: 'delete_account'.tr,
                      middleText: 'delete_account_confirmation'.tr,
                      textCancel: 'cancel'.tr,
                      textConfirm: 'delete'.tr,
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.red,
                      onConfirm: () {
                        Get.back();
                        Get.snackbar(
                          'account_deleted'.tr,
                          'account_deleted_message'.tr,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
