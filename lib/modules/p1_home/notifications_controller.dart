import 'package:get/get.dart';
import '../../app/models/notification_model.dart';
import '../../app/services/api_service.dart';

class NotificationsController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    notifications.value = ApiService.getSampleNotifications();
    updateUnreadCount();
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  void markAsRead(NotificationModel notification) {
    notification.isRead = true;
    notifications.refresh();
    updateUnreadCount();
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
    updateUnreadCount();
  }

  void openNotification(NotificationModel notification) {
    markAsRead(notification);
    // Navigate to article detail or relevant screen
    Get.snackbar(
      'Notification',
      'Opening: ${notification.title}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}
