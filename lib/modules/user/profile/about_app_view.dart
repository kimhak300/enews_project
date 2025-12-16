import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'about_app_controller.dart';

class AboutAppView extends GetView<AboutAppController> {
  const AboutAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('about_app'.tr),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 32.h),

            // App Icon
                      Container(
                        padding: EdgeInsets.all(6.w),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset('assets/images/logo1.png',
                              width: 100.dm, height: 100.dm),
                        ),
                      ),

            SizedBox(height: 24.h),

            // App Name
            Obx(() => Text(
                  controller.appName.value,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                )),

            SizedBox(height: 8.h),

            // Version
            Obx(() => Text(
                  'version'.tr + ' ${controller.version.value} (${controller.buildNumber.value})',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )),

            SizedBox(height: 32.h),

            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'app_description'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  height: 1.5,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ),

            SizedBox(height: 32.h),
            Divider(height: 1, thickness: 1),

            // Information List
            _buildInfoTile(
              context: context,
              icon: Icons.business_outlined,
              title: 'developer'.tr,
              subtitle: 'ENews Team',
            ),
            _buildInfoTile(
              context: context,
              icon: Icons.email_outlined,
              title: 'contact_email'.tr,
              subtitle: 'support@enews.com',
            ),
            _buildInfoTile(
              context: context,
              icon: Icons.language_outlined,
              title: 'website'.tr,
              subtitle: 'www.enews.com',
            ),
            _buildInfoTile(
              context: context,
              icon: Icons.location_on_outlined,
              title: 'location'.tr,
              subtitle: 'Phnom Penh, Cambodia',
            ),

            Divider(height: 1, thickness: 1),
            SizedBox(height: 16.h),

            // Action Buttons
            // _buildActionButton(
            //   context: context,
            //   icon: Icons.star_outline,
            //   title: 'rate_app'.tr,
            //   onTap: () {
            //     Get.snackbar(
            //       'coming_soon'.tr,
            //       'Rate app feature coming soon',
            //     );
            //   },
            // ),
            // _buildActionButton(
            //   context: context,
            //   icon: Icons.share_outlined,
            //   title: 'share_app'.tr,
            //   onTap: () {
            //     Get.snackbar(
            //       'coming_soon'.tr,
            //       'Share app feature coming soon',
            //     );
            //   },
            // ),
            _buildActionButton(
              context: context,
              icon: Icons.description_outlined,
              title: 'terms_of_service'.tr,
              onTap: () {
                _showTermsDialog(context);
              },
            ),
            _buildActionButton(
              context: context,
              icon: Icons.privacy_tip_outlined,
              title: 'privacy_policy'.tr,
              onTap: () {
                _showPrivacyPolicyDialog(context);
              },
            ),

            SizedBox(height: 32.h),

            // Copyright
            Text(
              "© 2025 ENews. ${'all_rights_reserved'.tr}",
              style: TextStyle(
                fontSize: 12.sp,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }

  void _showTermsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('terms_of_service'.tr),
        content: SingleChildScrollView(
          child: Text(
            'terms_content'.tr,
            style: TextStyle(fontSize: 14.sp),
          ),
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

  void _showPrivacyPolicyDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('privacy_policy'.tr),
        content: SingleChildScrollView(
          child: Text(
            'privacy_policy_content'.tr,
            style: TextStyle(fontSize: 14.sp),
          ),
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
}
