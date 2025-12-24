import 'package:flutter/foundation.dart';

enum NotificationType {
  orderValidated,
  materialPreparation,
  technicianOnRoute,
  installationInProgress,
  testVerification,
  installationComplete,
  general,
}

@immutable
class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? orderReference;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.orderReference,
  });

  String get iconPath {
    switch (type) {
      case NotificationType.orderValidated:
        return 'assets/Icones/notification/Task.svg';
      case NotificationType.materialPreparation:
        return 'assets/Icones/notification/Matériel.svg';
      case NotificationType.technicianOnRoute:
        return 'assets/Icones/notification/Tech.svg';
      case NotificationType.installationInProgress:
        return 'assets/Icones/notification/Installation.svg';
      case NotificationType.testVerification:
        return 'assets/Icones/notification/Test vérification.svg';
      case NotificationType.installationComplete:
        return 'assets/Icones/notification/Fibre.svg';
      case NotificationType.general:
        return 'assets/Icones/notification/Task.svg';
    }
  }

  String get formattedTime {
    return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? orderReference,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      orderReference: orderReference ?? this.orderReference,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
