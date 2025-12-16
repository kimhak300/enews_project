import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newshub/modules/organization/org_team/org_team_controller.dart';
import 'package:newshub/app/utils/image_utils.dart';

class OrgTeamView extends GetView<OrgTeamController> {
  const OrgTeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('team_members'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.teamMembers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.teamMembers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                SizedBox(height: 16.h),
                Text(controller.errorMessage.value),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.teamMembers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64.sp, color: Theme.of(context).disabledColor),
                SizedBox(height: 16.h),
                Text(
                  'no_team_members_yet'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ?? Theme.of(context).disabledColor,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              // Team Stats
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      'total_members'.tr,
                      controller.teamMembers.length.toString(),
                      Icons.people,
                    ),
                    Container(
                      width: 1,
                      height: 40.h,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                    _buildStatItem(
                      context,
                      'active'.tr,
                      controller.teamMembers
                          .where((m) => m['is_active'] == true)
                          .length
                          .toString(),
                      Icons.check_circle,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Team Members List
              Text(
                'team_members'.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 16.h),

              ...controller.teamMembers.map((member) {
                return _buildMemberCard(member);
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32.sp, color: Theme.of(context).colorScheme.primary),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member) {
    final isActive = member['is_active'] == true;

    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => controller.viewMemberDetails(member),
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    backgroundImage: resolveImageProvider(member['avatar'] as String?),
                    child: member['avatar'] == null
                        ? Text(
                            (member['display_name'] ?? 'U')[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 16.w),

                  // Member Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['display_name'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          member['email'] ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            // Role Badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                (member['role'] ?? 'user'),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: theme.colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Status Badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.green.withOpacity(0.15)
                                    : theme.disabledColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isActive ? Icons.check_circle : Icons.cancel,
                                    size: 12.sp,
                                    color: isActive ? Colors.green : theme.disabledColor,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    isActive ? 'active'.tr : 'inactive'.tr,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: isActive ? Colors.green : theme.disabledColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  Icon(Icons.chevron_right, color: theme.iconTheme.color?.withOpacity(0.4) ?? theme.disabledColor),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
