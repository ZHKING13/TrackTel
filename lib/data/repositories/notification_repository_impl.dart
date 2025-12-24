import '../../domain/entities/notification_entity.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final List<NotificationEntity> _notifications = [];

  @override
  Future<void> addNotification(NotificationEntity notification) async {
    _notifications.insert(0, notification);
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final sorted = List<NotificationEntity>.from(_notifications);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  @override
  Future<int> getUnreadCount() async {
    return _notifications.where((n) => !n.isRead).length;
  }
}
