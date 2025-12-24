import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/add_notification_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';

class NotificationsState {
  final List<NotificationEntity> notifications;
  final bool isLoading;
  final String? errorMessage;
  final int unreadCount;

  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.errorMessage,
    this.unreadCount = 0,
  });

  NotificationsState copyWith({
    List<NotificationEntity>? notifications,
    bool? isLoading,
    String? errorMessage,
    int? unreadCount,
    bool clearError = false,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final NotificationRepository _repository;
  final GetNotificationsUseCase _getNotificationsUseCase;
  final AddNotificationUseCase _addNotificationUseCase;

  NotificationsNotifier({
    required NotificationRepository repository,
    required GetNotificationsUseCase getNotificationsUseCase,
    required AddNotificationUseCase addNotificationUseCase,
  }) : _repository = repository,
       _getNotificationsUseCase = getNotificationsUseCase,
       _addNotificationUseCase = addNotificationUseCase,
       super(const NotificationsState());

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final notifications = await _getNotificationsUseCase.call();
      final unreadCount = await _repository.getUnreadCount();
      state = state.copyWith(
        notifications: notifications,
        isLoading: false,
        unreadCount: unreadCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement des notifications',
      );
    }
  }

  Future<void> addNotification({
    required String title,
    required String message,
    required NotificationType type,
    String? orderReference,
  }) async {
    try {
      await _addNotificationUseCase.call(
        title: title,
        message: message,
        type: type,
        orderReference: orderReference,
      );
      await loadNotifications();
    } catch (e) {}
  }

  Future<void> addWorkflowStepNotification({
    required int stepIndex,
    required String stepTitle,
    required String orderReference,
  }) async {
    final NotificationType type;
    final String message;

    switch (stepIndex) {
      case 0:
        type = NotificationType.orderValidated;
        message = 'Votre commande a été validée...';
        break;
      case 1:
        type = NotificationType.materialPreparation;
        message = 'Votre commande a atteint l\'étape...';
        break;
      case 2:
        type = NotificationType.technicianOnRoute;
        message = 'Le technicien est en route pour...';
        break;
      case 3:
        type = NotificationType.installationInProgress;
        message = 'L\'installation est en cours...';
        break;
      case 4:
        type = NotificationType.testVerification;
        message = 'Le technicien effectue des test...';
        break;
      case 5:
        type = NotificationType.installationComplete;
        message = 'Votre commande est terminée....';
        break;
      default:
        type = NotificationType.general;
        message = 'Mise à jour de votre commande';
    }

    await addNotification(
      title: stepTitle,
      message: message,
      type: type,
      orderReference: orderReference,
    );
  }

  Future<void> markAsRead(String notificationId) async {
    await _repository.markAsRead(notificationId);
    await loadNotifications();
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead();
    await loadNotifications();
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl();
});

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((
  ref,
) {
  return GetNotificationsUseCase(ref.read(notificationRepositoryProvider));
});

final addNotificationUseCaseProvider = Provider<AddNotificationUseCase>((ref) {
  return AddNotificationUseCase(ref.read(notificationRepositoryProvider));
});

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
      return NotificationsNotifier(
        repository: ref.read(notificationRepositoryProvider),
        getNotificationsUseCase: ref.read(getNotificationsUseCaseProvider),
        addNotificationUseCase: ref.read(addNotificationUseCaseProvider),
      );
    });

final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).unreadCount;
});
