import '../models/notification_model.dart';
import '../services/api_service.dart';
import '../local/storage_service.dart';

class NotificationRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService();
  
  static const String _notificationsKey = 'notifications';

  // Fetch notifications
  Future<List<NotificationModel>> getNotifications() async {
    // First try from cache
    final cachedNotifications = _getCachedNotifications();
    if (cachedNotifications.isNotEmpty) {
      return cachedNotifications;
    }

    // Fetch from API
    final notifications = await _apiService.fetchNotifications();
    await _cacheNotifications(notifications);
    return notifications;
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    final notifications = _getCachedNotifications();
    final index = notifications.indexWhere((n) => n.id == notificationId);
    
    if (index != -1) {
      notifications[index].isRead = true;
      await _cacheNotifications(notifications);
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    final notifications = _getCachedNotifications();
    for (var notification in notifications) {
      notification.isRead = true;
    }
    await _cacheNotifications(notifications);
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    final notifications = _getCachedNotifications();
    notifications.removeWhere((n) => n.id == notificationId);
    await _cacheNotifications(notifications);
  }

  // Clear all notifications
  Future<void> clearAll() async {
    await _storage.remove(_notificationsKey);
  }

  // Get unread count
  int getUnreadCount() {
    final notifications = _getCachedNotifications();
    return notifications.where((n) => !n.isRead).length;
  }

  // Private methods
  List<NotificationModel> _getCachedNotifications() {
    final notificationsData = _storage.read<List>(_notificationsKey);
    if (notificationsData == null) return [];
    
    return notificationsData
        .map((json) => NotificationModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<void> _cacheNotifications(List<NotificationModel> notifications) async {
    await _storage.write(
      _notificationsKey,
      notifications.map((n) => n.toJson()).toList(),
    );
  }
}
