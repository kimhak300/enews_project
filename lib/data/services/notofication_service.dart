import '../models/notification_model.dart';
import '../../app/config/api_constants.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _apiService = ApiService();

  // Get all notifications
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiService.get(ApiConstants.notifications);
      final List notificationsJson = response.data['data'] ?? [];
      return notificationsJson
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get unread count
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiService.get(ApiConstants.unreadCount);
      return response.data['unread_count'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Mark as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiService.put('${ApiConstants.markAsRead}/$notificationId/read');
    } catch (e) {
      rethrow;
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      await _apiService.put(ApiConstants.markAllAsRead);
    } catch (e) {
      rethrow;
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _apiService.delete('${ApiConstants.notifications}/$notificationId');
    } catch (e) {
      rethrow;
    }
  }
}