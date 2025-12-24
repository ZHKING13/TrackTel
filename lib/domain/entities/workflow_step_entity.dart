import 'package:flutter/foundation.dart';

/// Statuts possibles d'une étape du workflow
enum StepStatus { pending, inProgress, completed }

/// Entité WorkflowStep pour la couche domaine
@immutable
class WorkflowStepEntity {
  final String id;
  final String title;
  final String description;
  final String? time;
  final StepStatus status;
  final int order;

  const WorkflowStepEntity({
    required this.id,
    required this.title,
    required this.description,
    this.time,
    required this.status,
    required this.order,
  });

  /// Vérifie si l'étape est complétée
  bool get isCompleted => status == StepStatus.completed;

  /// Vérifie si l'étape est en cours
  bool get isInProgress => status == StepStatus.inProgress;

  /// Vérifie si l'étape est en attente
  bool get isPending => status == StepStatus.pending;

  /// Crée une copie avec les champs modifiés
  WorkflowStepEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    StepStatus? status,
    int? order,
  }) {
    return WorkflowStepEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      status: status ?? this.status,
      order: order ?? this.order,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkflowStepEntity &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.time == time &&
        other.status == status &&
        other.order == order;
  }

  @override
  int get hashCode {
    return Object.hash(id, title, description, time, status, order);
  }

  @override
  String toString() {
    return 'WorkflowStepEntity(id: $id, title: $title, status: $status, order: $order)';
  }
}
