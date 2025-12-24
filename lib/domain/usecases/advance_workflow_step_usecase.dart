import '../../data/repositories/workflow_repository.dart';
import '../entities/workflow_step_entity.dart';

/// Use case pour avancer à l'étape suivante du workflow
class AdvanceWorkflowStepUseCase {
  final WorkflowRepository _repository;

  AdvanceWorkflowStepUseCase(this._repository);

  Future<List<WorkflowStepEntity>> call({
    required List<WorkflowStepEntity> currentSteps,
    required int currentStepIndex,
    required String completionTime,
  }) async {
    return await _repository.advanceToNextStep(
      currentSteps: currentSteps,
      currentStepIndex: currentStepIndex,
      completionTime: completionTime,
    );
  }
}
