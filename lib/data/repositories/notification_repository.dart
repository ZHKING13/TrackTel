import '../../domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<void> addNotification(NotificationEntity notification);

  Future<List<NotificationEntity>> getNotifications();

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead();

  Future<void> deleteNotification(String notificationId);

  Future<int> getUnreadCount();
}
