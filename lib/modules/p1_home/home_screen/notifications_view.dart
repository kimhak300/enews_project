import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: controller.markAllAsRead,
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text('No notifications'),
          );
        }

        return ListView.separated(
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return Container(
              color: notification.isRead
                  ? Colors.transparent
                  : AppTheme.primaryColor.withValues(alpha: 0.05),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(notification.message),
                    const SizedBox(height: 4),
                    Text(
                      notification.getTimeAgo(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                onTap: () => controller.openNotification(notification),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
