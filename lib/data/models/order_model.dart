enum OrderType { fibre, sim, box, intervention }

enum OrderStatus { pending, inProgress, completed, cancelled }

class OrderModel {
  final String reference;

  final OrderType type;

  final OrderStatus status;

  final int progress;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  const OrderModel({
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
        return 'assets/Icones/home/Fibre.svg';
      case OrderType.sim:
        return 'assets/Icones/home/Sim.svg';
      case OrderType.box:
        return 'assets/Icones/home/box.svg';
      case OrderType.intervention:
        return 'assets/Icones/home/depanage.svg';
    }
  }

  OrderModel copyWith({
    String? reference,
    OrderType? type,
    OrderStatus? status,
    int? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      reference: reference ?? this.reference,
      type: type ?? this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      reference: json['reference'] as String,
      type: OrderType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => OrderType.fibre,
      ),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      progress: json['progress'] as int? ?? 0,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'type': type.name,
      'status': status.name,
      'progress': progress,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
