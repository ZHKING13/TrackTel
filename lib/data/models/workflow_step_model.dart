enum StepStatus { completed, inProgress, pending }

class WorkflowStepModel {
  final String id;
  final String title;
  final String? description;
  final String? time;
  final StepStatus status;
  final int order;

  const WorkflowStepModel({
    required this.id,
    required this.title,
    this.description,
    this.time,
    required this.status,
    required this.order,
  });

  WorkflowStepModel copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    StepStatus? status,
    int? order,
  }) {
    return WorkflowStepModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      status: status ?? this.status,
      order: order ?? this.order,
    );
  }

  static List<WorkflowStepModel> fibreInstallationSteps() {
    return const [
      WorkflowStepModel(
        id: 'step_1',
        title: 'Commande validée',
        description:
            'Votre commande a été confirmée et le processus d\'installation peut débuter.',
        time: 'Aujourd\'hui 09 h 00',
        status: StepStatus.completed,
        order: 1,
      ),
      WorkflowStepModel(
        id: 'step_2',
        title: 'Préparation du matériel',
        description:
            'Le matériel nécessaire à votre installation est en cours de préparation.',
        status: StepStatus.inProgress,
        order: 2,
      ),
      WorkflowStepModel(
        id: 'step_3',
        title: 'Technicien en route',
        description: 'Un technicien est en chemin vers votre domicile.',
        status: StepStatus.pending,
        order: 3,
      ),
      WorkflowStepModel(
        id: 'step_4',
        title: 'Installation en cours',
        description: 'L\'installation de votre fibre est en cours.',
        status: StepStatus.pending,
        order: 4,
      ),
      WorkflowStepModel(
        id: 'step_5',
        title: 'Tests et activation',
        description: 'Tests de connexion et activation de votre ligne.',
        status: StepStatus.pending,
        order: 5,
      ),
      WorkflowStepModel(
        id: 'step_6',
        title: 'Installation terminée',
        description:
            'Votre installation fibre est terminée. Profitez de votre connexion !',
        status: StepStatus.pending,
        order: 6,
      ),
    ];
  }
}
