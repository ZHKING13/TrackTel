import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../viewmodels/orders_viewmodel.dart';
import '../viewmodels/workflow_viewmodel.dart';
import '../viewmodels/notifications_viewmodel.dart';
import '../widgets/workflow_stepper.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final OrderEntity order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(ordersProvider.notifier).loadOrders();
      final order = await ref
          .read(ordersProvider.notifier)
          .getOrderByReference(widget.order.reference);
      if (order != null) {
        ref
            .read(workflowProvider.notifier)
            .initializeWorkflow(
              orderType: order.type,
              progress: order.progress,
            );
      } else {
        ref
            .read(workflowProvider.notifier)
            .initializeWorkflow(
              orderType: widget.order.type,
              progress: widget.order.progress,
            );
      }
    });
  }

  void _goToNextStep() async {
    final workflowNotifier = ref.read(workflowProvider.notifier);
    final workflowStateBefore = ref.read(workflowProvider);
    final completedStepIndex = workflowStateBefore.currentStepIndex;
    final now = DateTime.now();
    final completionTime =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final completedStepTitle = await workflowNotifier.advanceToNextStep(
      completionTime,
    );

    final workflowState = ref.read(workflowProvider);
    final nextStepTitle = workflowState.currentStepTitle;

    final totalSteps = workflowState.steps.length;
    final completedSteps =
        workflowState.steps.where((s) => s.isCompleted).length;
    final progress = ((completedSteps / totalSteps) * 100).round();

    await ref
        .read(ordersProvider.notifier)
        .updateOrderProgress(
          reference: widget.order.reference,
          progress: progress,
          status:
              workflowState.isCompleted
                  ? OrderStatus.completed
                  : OrderStatus.inProgress,
        );

    _sendStepNotification(
      completedStepTitle ?? '',
      completedStepIndex,
      nextStepTitle,
    );
  }

  void _sendStepNotification(
    String completedStepTitle,
    int completedStepIndex,
    String? nextStepTitle,
  ) {
    final notificationService = ref.read(notificationServiceProvider);
    final workflowState = ref.read(workflowProvider);

    if (!workflowState.isCompleted) {
      final currentStep =
          workflowState.currentStepTitle ?? nextStepTitle ?? completedStepTitle;
      notificationService.showNotification(
        title: 'Vous êtes à l\'étape : $currentStep',
        body: '',
      );
    }

    ref
        .read(notificationsProvider.notifier)
        .addWorkflowStepNotification(
          stepIndex: completedStepIndex,
          stepTitle: completedStepTitle,
          orderReference: widget.order.reference,
        );
  }

  bool _isTechnicianOnRoute(workflowState) {
    if (workflowState.currentStepIndex >= 0 &&
        workflowState.currentStepIndex < workflowState.steps.length) {
      final currentStep = workflowState.steps[workflowState.currentStepIndex];
      return currentStep.title.toLowerCase().contains('technicien en route');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final workflowState = ref.watch(workflowProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 16,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: const Text(
          'Détails de la commande',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body:
          workflowState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _OrderInfoHeader(
                    order: widget.order,
                    progress: workflowState.progress,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tracking',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              OutlinedButton(
                                onPressed:
                                    _isTechnicianOnRoute(workflowState)
                                        ? () {
                                          context.push(
                                            '/technician-location',
                                            extra: widget.order.reference,
                                          );
                                        }
                                        : null,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color:
                                        _isTechnicianOnRoute(workflowState)
                                            ? AppColors.primary
                                            : AppColors.textHint,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                child: Text(
                                  'Voir technicien',
                                  style: TextStyle(
                                    color:
                                        _isTechnicianOnRoute(workflowState)
                                            ? AppColors.primary
                                            : AppColors.textHint,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          WorkflowStepper(steps: workflowState.steps),
                        ],
                      ),
                    ),
                  ),

                  if (!workflowState.isCompleted)
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _goToNextStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  workflowState.isLastStep
                                      ? AppColors.primary
                                      : Colors.white,
                              foregroundColor:
                                  workflowState.isLastStep
                                      ? Colors.white
                                      : AppColors.textPrimary,
                              elevation: 0,
                              side:
                                  workflowState.isLastStep
                                      ? BorderSide.none
                                      : const BorderSide(
                                        color: AppColors.textHint,
                                      ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              workflowState.isLastStep
                                  ? 'Terminer'
                                  : 'Passer à l\'étape suivante',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
    );
  }
}

class _OrderInfoHeader extends StatelessWidget {
  final OrderEntity order;
  final int progress;

  const _OrderInfoHeader({required this.order, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Ref: ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    order.reference,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Statut: ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    order.statusLabel,
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Date: ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    order.createdAt != null
                        ? '${order.createdAt!.day.toString().padLeft(2, '0')}/${order.createdAt!.month.toString().padLeft(2, '0')}/${order.createdAt!.year}'
                        : '05/12/2025',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Type: ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    order.typeLabel,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Avancement:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              Text(
                '$progress%',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.inProgress:
        return AppColors.primary;
      case OrderStatus.completed:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }
}
