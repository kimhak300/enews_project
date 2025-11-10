import '../models/notification_model.dart';

class ApiService {
  static List<NotificationModel> getSampleNotifications() {
    final now = DateTime.now();
    return List.generate(
      10,
      (index) => NotificationModel(
        id: 'notif_$index',
        title: 'Breaking News Alert ${index + 1}',
        message: 'New article published in Technology category',
        timestamp: now.subtract(Duration(hours: index + 1)),
        type: 'article',
        isRead: index >= 3,
      ),
    );
  }
}
