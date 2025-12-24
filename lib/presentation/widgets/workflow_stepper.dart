import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/workflow_step_entity.dart';

class WorkflowStepper extends StatelessWidget {
  final List<WorkflowStepEntity> steps;

  const WorkflowStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;

            return _WorkflowStepItem(step: step, isLast: isLast);
          }).toList(),
    );
  }
}

class _WorkflowStepItem extends StatelessWidget {
  final WorkflowStepEntity step;
  final bool isLast;

  const _WorkflowStepItem({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isCompleted = step.status == StepStatus.completed;
    final isInProgress = step.status == StepStatus.inProgress;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                _StepIndicator(status: step.status),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: AppColors.primary),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isInProgress
                        ? AppColors.primary.withAlpha(20)
                        : isCompleted
                        ? AppColors.textSecondary.withAlpha(10)
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isInProgress
                          ? AppColors.primary.withAlpha(50)
                          : Colors.grey.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (step.time != null && isInProgress)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        step.time!,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isInProgress
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ),

                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  if (isInProgress)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        step.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final StepStatus status;

  const _StepIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(_getIconPath(), width: 24, height: 24),
    );
  }

  String _getIconPath() {
    switch (status) {
      case StepStatus.completed:
        return 'assets/Icones/tracking/confirme.svg';
      case StepStatus.inProgress:
        return 'assets/Icones/tracking/ongoing.svg';
      case StepStatus.pending:
        return 'assets/Icones/tracking/waiting.svg';
    }
  }
}
