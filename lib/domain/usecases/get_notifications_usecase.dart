import '../../data/repositories/notification_repository.dart';
import '../entities/notification_entity.dart';

class GetNotificationsUseCase {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<List<NotificationEntity>> call() {
    return _repository.getNotifications();
  }
}
