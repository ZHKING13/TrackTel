import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/workflow_repository.dart';
import '../../data/repositories/workflow_repository_impl.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/workflow_step_entity.dart';
import '../../domain/usecases/get_workflow_steps_usecase.dart';
import '../../domain/usecases/advance_workflow_step_usecase.dart';

class WorkflowState {
  final List<WorkflowStepEntity> steps;
  final int currentStepIndex;
  final bool isLoading;
  final String? errorMessage;

  const WorkflowState({
    this.steps = const [],
    this.currentStepIndex = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  WorkflowState copyWith({
    List<WorkflowStepEntity>? steps,
    int? currentStepIndex,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WorkflowState(
      steps: steps ?? this.steps,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  int get progress {
    if (steps.isEmpty) return 0;
    final completed = steps.where((s) => s.isCompleted).length;
    return ((completed / steps.length) * 100).round();
  }

  bool get isCompleted => currentStepIndex >= steps.length;

  bool get isLastStep => currentStepIndex == steps.length - 1;

  String? get currentStepTitle {
    if (currentStepIndex >= 0 && currentStepIndex < steps.length) {
      return steps[currentStepIndex].title;
    }
    return null;
  }
}

class WorkflowNotifier extends StateNotifier<WorkflowState> {
  final GetWorkflowStepsUseCase _getWorkflowStepsUseCase;
  final AdvanceWorkflowStepUseCase _advanceWorkflowStepUseCase;

  WorkflowNotifier({
    required GetWorkflowStepsUseCase getWorkflowStepsUseCase,
    required AdvanceWorkflowStepUseCase advanceWorkflowStepUseCase,
  }) : _getWorkflowStepsUseCase = getWorkflowStepsUseCase,
       _advanceWorkflowStepUseCase = advanceWorkflowStepUseCase,
       super(const WorkflowState());

  Future<void> initializeWorkflow({
    required OrderType orderType,
    required int progress,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final totalSteps = _getTotalSteps(orderType);
      final currentStep = _calculateCurrentStep(progress, totalSteps);

      final steps = await _getWorkflowStepsUseCase(
        orderType: orderType,
        currentStep: currentStep,
      );

      int currentStepIndex = steps.indexWhere((s) => s.isInProgress);
      if (currentStepIndex == -1) {
        currentStepIndex = steps.indexWhere((s) => s.isPending);
      }
      if (currentStepIndex == -1) {
        currentStepIndex = steps.length; 
      }

      state = state.copyWith(
        steps: steps,
        currentStepIndex: currentStepIndex,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement du workflow: $e',
      );
    }
  }

  Future<String?> advanceToNextStep(String completionTime) async {
    if (state.isCompleted) return null;

    try {
      final completedStepTitle = state.currentStepTitle;

      final updatedSteps = await _advanceWorkflowStepUseCase(
        currentSteps: state.steps,
        currentStepIndex: state.currentStepIndex,
        completionTime: completionTime,
      );

      state = state.copyWith(
        steps: updatedSteps,
        currentStepIndex: state.currentStepIndex + 1,
      );

      return completedStepTitle;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erreur lors de l\'avancement de l\'étape: $e',
      );
      return null;
    }
  }

  int _getTotalSteps(OrderType orderType) {
    switch (orderType) {
      case OrderType.fibre:
      case OrderType.box:
        return 6;
      case OrderType.sim:
        return 5;
      case OrderType.intervention:
        return 4;
    }
  }

  int _calculateCurrentStep(int progress, int totalSteps) {
    if (progress == 0) return 1;
    if (progress >= 100) return totalSteps + 1;
    return ((progress / 100) * totalSteps).ceil().clamp(1, totalSteps);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}


final workflowRepositoryProvider = Provider<WorkflowRepository>((ref) {
  return WorkflowRepositoryImpl();
});

final getWorkflowStepsUseCaseProvider = Provider<GetWorkflowStepsUseCase>((
  ref,
) {
  final repository = ref.watch(workflowRepositoryProvider);
  return GetWorkflowStepsUseCase(repository);
});

final advanceWorkflowStepUseCaseProvider = Provider<AdvanceWorkflowStepUseCase>(
  (ref) {
    final repository = ref.watch(workflowRepositoryProvider);
    return AdvanceWorkflowStepUseCase(repository);
  },
);

final workflowProvider = StateNotifierProvider<WorkflowNotifier, WorkflowState>(
  (ref) {
    return WorkflowNotifier(
      getWorkflowStepsUseCase: ref.watch(getWorkflowStepsUseCaseProvider),
      advanceWorkflowStepUseCase: ref.watch(advanceWorkflowStepUseCaseProvider),
    );
  },
);
