import 'package:flutter/foundation.dart';

enum OrderType { fibre, sim, box, intervention }

enum OrderStatus { pending, inProgress, completed, cancelled }

@immutable
class OrderEntity {
  final String reference;
  final OrderType type;
  final OrderStatus status;
  final int progress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderEntity({
    required this.reference,
    required this.type,
    required this.status,
    required this.progress,
    this.createdAt,
    this.updatedAt,
  });

  String get typeLabel {
    switch (type) {
      case OrderType.fibre:
        return 'Fibre';
      case OrderType.sim:
        return 'SIM';
      case OrderType.box:
        return 'Box';
      case OrderType.intervention:
        return 'Intervention';
    }
  }

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.inProgress:
        return 'En cours';
      case OrderStatus.completed:
        return 'Terminé';
      case OrderStatus.cancelled:
        return 'Annulé';
    }
  }

  String get iconPath {
    switch (type) {
      case OrderType.fibre:
        return 'assets/Icones/home/fibre.svg';
      case OrderType.sim:
        return 'assets/Icones/home/sim.svg';
      case OrderType.box:
        return 'assets/Icones/home/box.svg';
      case OrderType.intervention:
        return 'assets/Icones/home/depanage.svg';
    }
  }

  int get totalSteps {
    switch (type) {
      case OrderType.fibre:
      case OrderType.box:
        return 6;
      case OrderType.sim:
        return 5;
      case OrderType.intervention:
        return 4;
    }
  }

  OrderEntity copyWith({
    String? reference,
    OrderType? type,
    OrderStatus? status,
    int? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderEntity(
      reference: reference ?? this.reference,
      type: type ?? this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderEntity &&
        other.reference == reference &&
        other.type == type &&
        other.status == status &&
        other.progress == progress &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(reference, type, status, progress, createdAt, updatedAt);
  }

  @override
  String toString() {
    return 'OrderEntity(reference: $reference, type: $type, status: $status, progress: $progress)';
  }
}
