import '../../core/services/notification_service.dart';

class SendOtpNotificationUseCase {
  final NotificationService _notificationService;

  SendOtpNotificationUseCase(this._notificationService);

  Future<void> call({required String phoneNumber, required String otp}) async {
    await _notificationService.showOtpNotification(
      phoneNumber: phoneNumber,
      otp: otp,
    );
  }
}
