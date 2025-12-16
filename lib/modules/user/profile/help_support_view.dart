import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'help_support_controller.dart';

class HelpSupportView extends GetView<HelpSupportController> {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('help_support'.tr),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Support Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 64.sp,
                    color: theme.colorScheme.onPrimary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'need_help'.tr,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'we_are_here_to_help'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Contact Options
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'contact_us'.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            _buildContactOption(
              context: context,
              icon: Icons.email_outlined,
              title: 'email_support'.tr,
              subtitle: 'kimhak029@gmail.com',
              onTap: () {
                // Get.snackbar(
                //   'contact'.tr,
                //   'Opening email client...',
                // );
              },
            ),

            _buildContactOption(
              context: context,
              icon: Icons.phone_outlined,
              title: 'phone_support'.tr,
              subtitle: '+855 884 317 616',
              onTap: () {
                // Get.snackbar(
                //   'contact'.tr,
                //   'Opening phone dialer...',
                // );
              },
            ),

            _buildContactOption(
              context: context,
              icon: Icons.chat_outlined,
              title: 'live_chat'.tr,
              subtitle: 'available_24_7'.tr,
              onTap: () {
                // Get.snackbar(
                //   'coming_soon'.tr,
                //   'Live chat feature coming soon',
                // );
              },
            ),

            SizedBox(height: 12.h),

            // Obx(() => ListView.builder(
            //       shrinkWrap: true,
            //       physics: const NeverScrollableScrollPhysics(),
            //       padding: EdgeInsets.symmetric(horizontal: 16.w),
            //       itemCount: controller.faqs.length,
            //       itemBuilder: (context, index) {
            //         final faq = controller.faqs[index];
            //         final isExpanded =
            //             controller.expandedFaqIndex.value == index;

            //         return Card(
            //           margin: EdgeInsets.only(bottom: 12.h),
            //           elevation: 0,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12.r),
            //             side: BorderSide(
            //               color: theme.colorScheme.outline.withOpacity(0.2),
            //             ),
            //           ),
            //           child: InkWell(
            //             borderRadius: BorderRadius.circular(12.r),
            //             onTap: () => controller.toggleFaq(index),
            //             child: Padding(
            //               padding: EdgeInsets.all(16.w),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Row(
            //                     children: [
            //                       Expanded(
            //                         child: Text(
            //                           faq['question']!.tr,
            //                           style: TextStyle(
            //                             fontSize: 15.sp,
            //                             fontWeight: FontWeight.w600,
            //                             color: theme.colorScheme.onSurface,
            //                           ),
            //                         ),
            //                       ),
            //                       Icon(
            //                         isExpanded
            //                             ? Icons.expand_less
            //                             : Icons.expand_more,
            //                         color: theme.colorScheme.primary,
            //                       ),
            //                     ],
            //                   ),
            //                   if (isExpanded) ...[
            //                     SizedBox(height: 12.h),
            //                     Text(
            //                       faq['answer']!.tr,
            //                       style: TextStyle(
            //                         fontSize: 14.sp,
            //                         height: 1.5,
            //                         color: theme.colorScheme.onSurfaceVariant,
            //                       ),
            //                     ),
            //                   ],
            //                 ],
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     )),

            // SizedBox(height: 24.h),
            // Divider(height: 1, thickness: 1),
            // SizedBox(height: 24.h),

            // Send Feedback Button
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.w),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton.icon(
            //       onPressed: () => _showFeedbackDialog(context),
            //       icon: const Icon(Icons.feedback_outlined),
            //       label: Text('send_feedback'.tr),
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: theme.colorScheme.primary,
            //         foregroundColor: theme.colorScheme.onPrimary,
            //         padding: EdgeInsets.symmetric(vertical: 16.h),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12.r),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(6.w),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.asset('assets/images/logo1.png',
                width: 24.w, height: 24.h),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
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
        // trailing: Icon(
        //   Icons.arrow_forward_ios,
        //   size: 16.sp,
        //   color: theme.colorScheme.onSurfaceVariant,
        // ),
        onTap: onTap,
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final theme = Theme.of(context);
    final feedbackController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('send_feedback'.tr),
        content: TextField(
          controller: feedbackController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'feedback_placeholder'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            filled: true,
            fillColor:
                theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              if (feedbackController.text.trim().isNotEmpty) {
                controller.sendFeedback(feedbackController.text.trim());
              } else {
                Get.snackbar(
                  'error'.tr,
                  'Please enter your feedback',
                );
              }
            },
            child: Text('send'.tr),
          ),
        ],
      ),
    );
  }
}
