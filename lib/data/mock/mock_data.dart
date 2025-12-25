import '../models/order_model.dart';
import '../models/workflow_step_model.dart';

class MockData {
  MockData._();


  static final List<OrderModel> orders = [
    OrderModel(
      reference: 'FIB-20-0012',
      type: OrderType.fibre,
      status: OrderStatus.inProgress,
      progress: 17,
      createdAt: DateTime(2025, 12, 5),
      updatedAt: DateTime(2025, 12, 24),
    ),
    OrderModel(
      reference: 'SIM-20-0045',
      type: OrderType.sim,
      status: OrderStatus.completed,
      progress: 100,
      createdAt: DateTime(2025, 11, 20),
      updatedAt: DateTime(2025, 11, 25),
    ),

    OrderModel(
      reference: 'SIM-20-0067',
      type: OrderType.sim,
      status: OrderStatus.cancelled,
      progress: 30,
      createdAt: DateTime(2025, 12, 1),
      updatedAt: DateTime(2025, 12, 5),
    ),
  ];

  static OrderModel? getOrderByReference(String reference) {
    try {
      return orders.firstWhere((order) => order.reference == reference);
    } catch (e) {
      return null;
    }
  }

  static List<OrderModel> getOrdersByStatus(OrderStatus status) {
    return orders.where((order) => order.status == status).toList();
  }

  static List<OrderModel> getOrdersByType(OrderType type) {
    return orders.where((order) => order.type == type).toList();
  }

  static List<OrderModel> getActiveOrders() {
    return orders
        .where(
          (order) =>
              order.status == OrderStatus.inProgress ||
              order.status == OrderStatus.pending,
        )
        .toList();
  }

  static void updateOrder(
    String reference, {
    int? progress,
    OrderStatus? status,
  }) {
    final index = orders.indexWhere((order) => order.reference == reference);
    if (index != -1) {
      orders[index] = orders[index].copyWith(
        progress: progress,
        status: status,
        updatedAt: DateTime.now(),
      );
    }
  }

  static List<WorkflowStepModel> getFibreWorkflowSteps({int currentStep = 1}) {
    return [
      WorkflowStepModel(
        id: 'step_1',
        title: 'Commande validée',
        description:
            'Votre commande a été confirmée et le processus d\'installation peut débuter.',
        time: 'Aujourd\'hui 09 h 00',
        status:
            currentStep > 1
                ? StepStatus.completed
                : (currentStep == 1
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 1,
      ),
      WorkflowStepModel(
        id: 'step_2',
        title: 'Préparation du matériel',
        description:
            'Le matériel nécessaire à votre installation est en cours de préparation.',
        time: currentStep >= 2 ? 'Aujourd\'hui 10 h 30' : null,
        status:
            currentStep > 2
                ? StepStatus.completed
                : (currentStep == 2
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 2,
      ),
      WorkflowStepModel(
        id: 'step_3',
        title: 'Technicien en route',
        description: 'Un technicien est en chemin vers votre domicile.',
        time: currentStep >= 3 ? 'Aujourd\'hui 11 h 00' : null,
        status:
            currentStep > 3
                ? StepStatus.completed
                : (currentStep == 3
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 3,
      ),
      WorkflowStepModel(
        id: 'step_4',
        title: 'Installation en cours',
        description: 'L\'installation de votre fibre est en cours.',
        time: currentStep >= 4 ? 'Aujourd\'hui 14 h 00' : null,
        status:
            currentStep > 4
                ? StepStatus.completed
                : (currentStep == 4
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 4,
      ),
      WorkflowStepModel(
        id: 'step_5',
        title: 'Tests et activation',
        description: 'Tests de connexion et activation de votre ligne.',
        time: currentStep >= 5 ? 'Aujourd\'hui 16 h 00' : null,
        status:
            currentStep > 5
                ? StepStatus.completed
                : (currentStep == 5
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 5,
      ),
      WorkflowStepModel(
        id: 'step_6',
        title: 'Installation terminée',
        description:
            'Votre installation fibre est terminée. Profitez de votre connexion !',
        time: currentStep >= 6 ? 'Aujourd\'hui 17 h 00' : null,
        status:
            currentStep > 6
                ? StepStatus.completed
                : (currentStep == 6
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 6,
      ),
    ];
  }

  static List<WorkflowStepModel> getInterventionWorkflowSteps({
    int currentStep = 1,
  }) {
    return [
      WorkflowStepModel(
        id: 'step_1',
        title: 'Demande reçue',
        description: 'Votre demande d\'intervention a été enregistrée.',
        time: 'Aujourd\'hui 08 h 00',
        status:
            currentStep > 1
                ? StepStatus.completed
                : (currentStep == 1
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 1,
      ),
      WorkflowStepModel(
        id: 'step_2',
        title: 'Diagnostic en cours',
        description: 'Notre équipe analyse votre problème.',
        time: currentStep >= 2 ? 'Aujourd\'hui 09 h 00' : null,
        status:
            currentStep > 2
                ? StepStatus.completed
                : (currentStep == 2
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 2,
      ),
      WorkflowStepModel(
        id: 'step_3',
        title: 'Technicien assigné',
        description: 'Un technicien a été assigné à votre dossier.',
        time: currentStep >= 3 ? 'Aujourd\'hui 10 h 00' : null,
        status:
            currentStep > 3
                ? StepStatus.completed
                : (currentStep == 3
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 3,
      ),
      WorkflowStepModel(
        id: 'step_4',
        title: 'Intervention terminée',
        description: 'Le problème a été résolu.',
        time: currentStep >= 4 ? 'Aujourd\'hui 12 h 00' : null,
        status:
            currentStep > 4
                ? StepStatus.completed
                : (currentStep == 4
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 4,
      ),
    ];
  }

  static List<WorkflowStepModel> getSimWorkflowSteps({int currentStep = 1}) {
    return [
      WorkflowStepModel(
        id: 'step_1',
        title: 'Commande reçue',
        description: 'Votre commande de carte SIM a été enregistrée.',
        time: currentStep >= 1 ? '15/07/205 à 07 h 00' : null,
        status:
            currentStep > 1
                ? StepStatus.completed
                : (currentStep == 1
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 1,
      ),
      WorkflowStepModel(
        id: 'step_2',
        title: 'SIM préparée',
        description: 'Votre carte SIM est en cours de préparation.',
        time: currentStep >= 2 ? '18/07/205 à 08 h 00' : null,
        status:
            currentStep > 2
                ? StepStatus.completed
                : (currentStep == 2
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 2,
      ),
      WorkflowStepModel(
        id: 'step_3',
        title: 'Expédiée',
        description: 'Votre carte SIM a été expédiée.',
        time: currentStep >= 3 ? '20/07/205 à 08 h 00' : null,
        status:
            currentStep > 3
                ? StepStatus.completed
                : (currentStep == 3
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 3,
      ),
      WorkflowStepModel(
        id: 'step_4',
        title: 'En livraison',
        description: 'Votre carte SIM est en cours de livraison.',
        time: currentStep >= 4 ? '22/07/205 à 08 h 00' : null,
        status:
            currentStep > 4
                ? StepStatus.completed
                : (currentStep == 4
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 4,
      ),
      WorkflowStepModel(
        id: 'step_5',
        title: 'SIM Livrée',
        description: 'Votre carte SIM a été livrée. Vous pouvez l\'activer.',
        time: currentStep >= 5 ? '27/07/205 à 08 h 00' : null,
        status:
            currentStep > 5
                ? StepStatus.completed
                : (currentStep == 5
                    ? StepStatus.inProgress
                    : StepStatus.pending),
        order: 5,
      ),
    ];
  }
}
