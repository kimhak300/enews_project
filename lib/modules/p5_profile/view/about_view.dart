import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(Get.context!);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('About & Help'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: theme.cardColor,
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.newspaper,
                        size: 60,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'eNews',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => Text(
                  'Version ${controller.appVersion.value}',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                )),
                const SizedBox(height: 4),
                Text(
                  '© 2024 eNews. All rights reserved.',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: theme.cardColor,
            child: Column(
              children: [
                ListTile(
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.openTermsOfService,
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.openPrivacyPolicy,
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Contact Support'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.contactSupport,
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('FAQ'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.openFAQ,
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Rate App'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.rateApp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
