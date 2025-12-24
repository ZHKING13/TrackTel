import '../../data/repositories/workflow_repository.dart';
import '../entities/order_entity.dart';
import '../entities/workflow_step_entity.dart';

/// Use case pour récupérer les étapes du workflow d'une commande
class GetWorkflowStepsUseCase {
  final WorkflowRepository _repository;

  GetWorkflowStepsUseCase(this._repository);

  Future<List<WorkflowStepEntity>> call({
    required OrderType orderType,
    required int currentStep,
  }) async {
    return await _repository.getWorkflowSteps(
      orderType: orderType,
      currentStep: currentStep,
    );
  }
}
