import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShareBottomSheet extends StatelessWidget {
  final String title;
  final String content;
  final int articleId;
  final Function(String platform) onShare;

  const ShareBottomSheet({
    super.key,
    required this.title,
    required this.content,
    required this.articleId,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Social Media Icons Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(
                  context: context,
                  icon: 'assets/images/facebook.png',
                  label: 'Facebook',
                  color: const Color(0xFF1877F2),
                  onTap: () {
                    onShare('facebook');
                    Get.back();
                  },
                ),
                _buildSocialButton(
                  context: context,
                  icon: 'assets/images/messenger.png',
                  label: 'Messenger',
                  color: const Color(0xFF0084FF),
                  onTap: () {
                    onShare('messenger');
                    Get.back();
                  },
                ),
                _buildSocialButton(
                  context: context,
                  icon: 'assets/images/wechat.png',
                  label: 'WeChat',
                  color: const Color(0xFF7BB32E),
                  onTap: () {
                    onShare('wechat');
                    Get.back();
                  },
                ),
                _buildSocialButton(
                  context: context,
                  icon: 'assets/images/twitter.png',
                  label: 'Twitter',
                  color: const Color(0xFF1DA1F2),
                  onTap: () {
                    onShare('twitter');
                    Get.back();
                  },
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.outlineVariant,
          ),

          SizedBox(height: 16.h),

          // Action Icons Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context: context,
                  icon: Icons.link,
                  label: 'copy_link'.tr,
                  onTap: () async {
                    final shareText = '''$title\n\n$content\n\nRead more at: NewsHub''';
                    await Clipboard.setData(ClipboardData(text: shareText));
                    onShare('copy_link');
                    Get.back();
                    Get.snackbar(
                      'success'.tr,
                      'Link copied to clipboard!',
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      colorText: theme.colorScheme.onSurfaceVariant,
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
                // _buildActionButton(
                //   context: context,
                //   icon: Icons.bookmark_border,
                //   label: 'favorite'.tr,
                //   onTap: () {
                //     Get.back();
                //     // Handle favorite - this would be handled by parent
                //   },
                // ),
                _buildActionButton(
                  context: context,
                  icon: Icons.forward,
                  label: 'forward'.tr,
                  onTap: () {
                    onShare('forward');
                    Get.back();
                  },
                ),
                _buildActionButton(
                  context: context,
                  icon: Icons.ios_share,
                  label: 'share'.tr,
                  onTap: () {
                    onShare('system_share');
                    Get.back();
                  },
                ),
                _buildActionButton(
                  context: context,
                  icon: Icons.report_outlined,
                  label: 'report'.tr,
                  onTap: () {
                    Get.back();
                    // Handle report - this would be handled by parent
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Cancel Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'cancel'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                _getSocialIcon(label),
                color: Colors.white,
                size: 32.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSocialIcon(String label) {
    switch (label.toLowerCase()) {
      case 'facebook':
        return Icons.facebook;
      case 'messenger':
        return Icons.message;
      case 'line':
        return Icons.message_outlined;
      case 'wechat':
        return Icons.chat;
      case 'twitter':
        return Icons.alternate_email;
      default:
        return Icons.share;
    }
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.onSurface,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
