import '../../data/repositories/notification_repository.dart';
import '../entities/notification_entity.dart';

class AddNotificationUseCase {
  final NotificationRepository _repository;

  AddNotificationUseCase(this._repository);

  Future<void> call({
    required String title,
    required String message,
    required NotificationType type,
    String? orderReference,
  }) async {
    final notification = NotificationEntity(
      id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      orderReference: orderReference,
    );
    await _repository.addNotification(notification);
  }
}
