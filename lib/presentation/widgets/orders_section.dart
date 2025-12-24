import 'package:flutter/material.dart';
import 'package:tracktel/core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import 'order_dashboard_card.dart';

class OrdersSection extends StatelessWidget {
  final List<OrderEntity> orders;

  final void Function(OrderEntity order)? onViewDetails;

  final void Function(OrderEntity order)? onOrderTap;

  final String title;

  const OrdersSection({
    super.key,
    required this.orders,
    this.onViewDetails,
    this.onOrderTap,
    this.title = 'Mes commandes',
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return _EmptyOrdersState(title: title);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(1),
      // decoration: BoxDecoration(
      //   color: AppColors.surface,
      //   borderRadius: BorderRadius.circular(16),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          ...orders.asMap().entries.map((entry) {
            final index = entry.key;
            final order = entry.value;
            final isLast = index == orders.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: OrderDashboardCard(
                order: order,
                onViewDetails:
                    onViewDetails != null ? () => onViewDetails!(order) : null,
                onTap: onOrderTap != null ? () => onOrderTap!(order) : null,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EmptyOrdersState extends StatelessWidget {
  final String title;

  const _EmptyOrdersState({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'Aucune commande',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
