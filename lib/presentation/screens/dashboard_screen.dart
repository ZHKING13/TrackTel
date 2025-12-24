import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../viewmodels/orders_viewmodel.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/box_status_cards.dart';
import '../widgets/orders_section.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _selectedLine = 'Ligne fibre ---';

  final List<String> _lines = [
    'Ligne fibre ---',
    'Ligne mobile 1',
    'Ligne mobile 2',
  ];

  late List<BoxStatusData> _boxStatusData;

  @override
  void initState() {
    super.initState();
    _boxStatusData = const [
      BoxStatusData(
        label: 'Box',
        value: '---',
        iconPath: 'assets/Icones/home/box.svg',
      ),
      BoxStatusData(
        label: 'Internet',
        value: '---',
        iconPath: 'assets/Icones/home/Wifi.svg',
      ),
      BoxStatusData(
        label: 'Dernier test',
        value: '---',
        iconPath: 'assets/Icones/home/Test.svg',
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).loadOrders();
    });
  }

  void _navigateToOrderDetails(OrderEntity order) {
    context.push(AppRouter.orderDetails, extra: order);
  }

  void _navigateToClaim() {
    final ordersState = ref.read(ordersProvider);
    final orderReference =
        ordersState.orders.isNotEmpty
            ? ordersState.orders.first.reference
            : 'DEFAULT';
    context.push(AppRouter.claim, extra: orderReference);
  }

  void _testConnection() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test de connexion en cours...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _navigateToClaim,
            icon: const Icon(
              Icons.edit_note,
              size: 20,
              color: AppColors.primary,
            ),
            label: const Text(
              'Faire une réclamation',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _testConnection,
            icon: const Icon(Icons.wifi_find, size: 20, color: Colors.white),
            label: const Text(
              'Tester ma connexion',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardHeader(
                  userName: 'Eddy',
                  lines: _lines,
                  selectedLine: _selectedLine,
                  onLineChanged: (newLine) {
                    setState(() {
                      _selectedLine = newLine;
                    });
                  },
                  boxStatusCards: _boxStatusData,
                  onCardTap: (index) {
                    debugPrint('Card tapped: $index');
                  },
                ),
                const SizedBox(height: 24),

                // Boutons Actions (Réclamation + Test connexion)
                _buildActionButtons(),
                const SizedBox(height: 24),

                if (ordersState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (ordersState.errorMessage != null)
                  Center(child: Text(ordersState.errorMessage!))
                else
                  OrdersSection(
                    orders: ordersState.orders,
                    onViewDetails: _navigateToOrderDetails,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
