import '../../domain/entities/order_entity.dart';
import '../../domain/entities/workflow_step_entity.dart';
import '../mock/mock_data.dart';
import '../models/workflow_step_model.dart' as model;
import 'workflow_repository.dart';

class WorkflowRepositoryImpl implements WorkflowRepository {
  @override
  Future<List<WorkflowStepEntity>> getWorkflowSteps({
    required OrderType orderType,
    required int currentStep,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    List<model.WorkflowStepModel> steps;

    switch (orderType) {
      case OrderType.fibre:
      case OrderType.box:
        steps = MockData.getFibreWorkflowSteps(currentStep: currentStep);
        break;
      case OrderType.sim:
        steps = MockData.getSimWorkflowSteps(currentStep: currentStep);
        break;
      case OrderType.intervention:
        steps = MockData.getInterventionWorkflowSteps(currentStep: currentStep);
        break;
    }

    return steps.map(_mapModelToEntity).toList();
  }

  @override
  Future<List<WorkflowStepEntity>> advanceToNextStep({
    required List<WorkflowStepEntity> currentSteps,
    required int currentStepIndex,
    required String completionTime,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final updatedSteps = List<WorkflowStepEntity>.from(currentSteps);

    if (currentStepIndex >= 0 && currentStepIndex < updatedSteps.length) {
      updatedSteps[currentStepIndex] = updatedSteps[currentStepIndex].copyWith(
        status: StepStatus.completed,
        time: completionTime,
      );
    }

    final nextStepIndex = currentStepIndex + 1;
    if (nextStepIndex < updatedSteps.length) {
      updatedSteps[nextStepIndex] = updatedSteps[nextStepIndex].copyWith(
        status: StepStatus.inProgress,
      );
    }

    return updatedSteps;
  }

  WorkflowStepEntity _mapModelToEntity(model.WorkflowStepModel stepModel) {
    return WorkflowStepEntity(
      id: stepModel.id,
      title: stepModel.title,
      description: stepModel.description ?? '',
      time: stepModel.time,
      status: _mapStatusFromModel(stepModel.status),
      order: stepModel.order,
    );
  }

  StepStatus _mapStatusFromModel(model.StepStatus modelStatus) {
    switch (modelStatus) {
      case model.StepStatus.pending:
        return StepStatus.pending;
      case model.StepStatus.inProgress:
        return StepStatus.inProgress;
      case model.StepStatus.completed:
        return StepStatus.completed;
    }
  }
}
