import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_user/manage_users_controller.dart';
import 'package:newshub/modules/admin/manage_user/widgets/add_user_bottom_sheet.dart';
import 'package:newshub/modules/admin/manage_user/widgets/user_card_widget.dart';

class ManageUsersView extends GetView<ManageUsersController> {
  const ManageUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text('manage_users'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refresh,
          ),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: theme.colorScheme.onPrimary,
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onPrimary.withOpacity(0.75),
          tabs:  [
            Tab(text: "all".tr),
            Tab(text: "user".tr),
            Tab(text: "organizer".tr),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
        label: Text('create_user'.tr, style: TextStyle(color: theme.colorScheme.onPrimary)),
        onPressed: () => _openBottomSheet(context),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return TabBarView(
          controller: controller.tabController,
          children: [
            _buildUserList(controller.allUsers),
            _buildUserList(controller.userRoleUsers),
            _buildUserList(controller.organizerUsers),
          ],
        );
      }),
    );
  }

  Widget _buildUserList(List users) {
    return RefreshIndicator(
      onRefresh: () async => controller.refresh(),
      child: users.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 100),
                Center(child: Text("No users found.")),
              ],
            )
          : ListView.separated(
              padding: EdgeInsets.all(AppSpacing.paddingS),
              itemCount: users.length + (controller.hasMore ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                if (i >= users.length) {
                  controller.loadMore();
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final user = users[i];
                return UserCardWidget(
                  userId: user.id,
                  displayName: user.name,
                  email: user.email,
                  role: user.roles?.isNotEmpty == true
                      ? user.roles!.first.roleName
                      : (user.role ?? 'user'),
                  avatarUrl: user.avatarUrl ?? "",
                  onDelete: () => _showDeleteConfirmation(user),

                );
              },
            ),
    );
  }

  void _showDeleteConfirmation(user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteUser(user.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showRoleDialog(user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Manage User Roles'),
        content: Obx(() {
          if (controller.roles.isEmpty) {
            return const Text('Loading roles...');
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current roles: ${user.roles?.map((r) => r.roleName).join(", ") ?? "None"}'),
              const SizedBox(height: 16),
              ...controller.roles.map((role) {
                final hasRole = user.roles?.any((r) => r.id == role.id) ?? false;
                return CheckboxListTile(
                  title: Text(role.roleName),
                  value: hasRole,
                  onChanged: (value) {
                    if (value == true) {
                      controller.assignRoleToUser(user.id, role.id);
                    } else {
                      controller.removeRoleFromUser(user.id, role.id);
                    }
                    Get.back();
                  },
                );
              }).toList(),
            ],
          );
        }),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: const AddUserBottomSheet(),
            ),
          );
        },
      ),
    );
  }
}