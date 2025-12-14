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
      backgroundColor: Colors.grey[50],
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
                Icon(Icons.people_outline, size: 64.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'no_team_members_yet'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
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
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'total_members'.tr,
                      controller.teamMembers.length.toString(),
                      Icons.people,
                    ),
                    Container(
                      width: 1,
                      height: 40.h,
                      color: Colors.blue[200],
                    ),
                    _buildStatItem(
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
                  color: Colors.black87,
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

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32.sp, color: Colors.blue),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member) {
    final isActive = member['is_active'] == true;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                backgroundColor: Colors.blue[100],
                backgroundImage: resolveImageProvider(member['avatar'] as String?),
                child: member['avatar'] == null
                    ? Text(
                        (member['display_name'] ?? 'U')[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
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
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      member['email'] ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black54,
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
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            (member['role'] ?? 'user'),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.purple,
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
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isActive ? Icons.check_circle : Icons.cancel,
                                size: 12.sp,
                                color: isActive ? Colors.green : Colors.grey,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                isActive ? 'active'.tr : 'inactive'.tr,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isActive ? Colors.green : Colors.grey,
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
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
