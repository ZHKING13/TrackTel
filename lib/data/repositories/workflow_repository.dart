import '../../domain/entities/order_entity.dart';
import '../../domain/entities/workflow_step_entity.dart';

abstract class WorkflowRepository {
  Future<List<WorkflowStepEntity>> getWorkflowSteps({
    required OrderType orderType,
    required int currentStep,
  });

  Future<List<WorkflowStepEntity>> advanceToNextStep({
    required List<WorkflowStepEntity> currentSteps,
    required int currentStepIndex,
    required String completionTime,
  });
}
