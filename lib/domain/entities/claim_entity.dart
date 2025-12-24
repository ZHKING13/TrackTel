import 'package:flutter/foundation.dart';

enum ClaimReason { internetNotWorking, boxOutOfService, speedIssue, other }

enum ClaimStatus { pending, inProgress, resolved, rejected }

@immutable
class ClaimEntity {
  final String? id;
  final String orderReference;
  final ClaimReason reason;
  final String comment;
  final ClaimStatus status;
  final DateTime? createdAt;

  const ClaimEntity({
    this.id,
    required this.orderReference,
    required this.reason,
    required this.comment,
    this.status = ClaimStatus.pending,
    this.createdAt,
  });

  String get reasonLabel {
    switch (reason) {
      case ClaimReason.internetNotWorking:
        return 'Internet ne fonctionne pas';
      case ClaimReason.boxOutOfService:
        return 'Box hors service';
      case ClaimReason.speedIssue:
        return 'Problème de débit';
      case ClaimReason.other:
        return 'Autre';
    }
  }

  String get statusLabel {
    switch (status) {
      case ClaimStatus.pending:
        return 'En attente';
      case ClaimStatus.inProgress:
        return 'En cours de traitement';
      case ClaimStatus.resolved:
        return 'Résolue';
      case ClaimStatus.rejected:
        return 'Rejetée';
    }
  }

  static List<ClaimReason> get availableReasons => ClaimReason.values;

  static String getReasonLabel(ClaimReason reason) {
    switch (reason) {
      case ClaimReason.internetNotWorking:
        return 'Internet ne fonctionne pas';
      case ClaimReason.boxOutOfService:
        return 'Box hors service';
      case ClaimReason.speedIssue:
        return 'Problème de débit';
      case ClaimReason.other:
        return 'Autre';
    }
  }

  ClaimEntity copyWith({
    String? id,
    String? orderReference,
    ClaimReason? reason,
    String? comment,
    ClaimStatus? status,
    DateTime? createdAt,
  }) {
    return ClaimEntity(
      id: id ?? this.id,
      orderReference: orderReference ?? this.orderReference,
      reason: reason ?? this.reason,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClaimEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          orderReference == other.orderReference &&
          reason == other.reason &&
          comment == other.comment &&
          status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      orderReference.hashCode ^
      reason.hashCode ^
      comment.hashCode ^
      status.hashCode;
}
