import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../domain/entities/order_entity.dart';
import '../viewmodels/orders_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/box_status_cards.dart';
import '../widgets/orders_section.dart';
import '../widgets/connection_test_bottom_sheet.dart';
import '../widgets/connection_test_result_bottom_sheet.dart';
import '../widgets/action_buttons.dart';

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).loadOrders();

      // Afficher la notification de bienvenue si l'utilisateur vient de se connecter
      final authState = ref.read(authProvider);
      if (authState.justLoggedIn == true) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: const Text(
              'Connexion réussie. Bienvenue dans TrackTel.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            actions: [
              SizedBox.shrink(), 
            ],
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        });
        
        ref.read(authProvider.notifier).resetJustLoggedIn();
      }
    });
  }

  List<BoxStatusData> _getBoxStatusData(bool isFibreCompleted) {
    if (isFibreCompleted) {
      return const [
        BoxStatusData(
          label: 'Box',
          value: 'En ligne',
          iconPath: 'assets/Icones/home/box.svg',
          showStatusDot: true,
          statusDotColor: Colors.green,
        ),
        BoxStatusData(
          label: 'Internet',
          value: 'Connecté',
          iconPath: 'assets/Icones/home/Wifi.svg',
          showStatusDot: true,
          statusDotColor: Colors.green,
        ),
        BoxStatusData(
          label: 'Dernier test',
          value: 'Réussi',
          iconPath: 'assets/Icones/home/Test.svg',
          showStatusDot: true,
          statusDotColor: Colors.green,
        ),
      ];
    } else {
      return const [
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
    }
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => ConnectionTestBottomSheet(
            onTestComplete: (isSuccess) {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  _showTestResult(isSuccess);
                }
              });
            },
          ),
    );
  }

  void _showTestResult(bool isSuccess) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => ConnectionTestResultBottomSheet(
            isSuccess: isSuccess,
            onRetry: _testConnection,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);

    final hasFibreOrderCompleted = ordersState.orders.any(
      (order) =>
          order.type == OrderType.fibre &&
          order.status == OrderStatus.completed,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
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
                boxStatusCards: _getBoxStatusData(hasFibreOrderCompleted),
                onCardTap: (index) {
                  debugPrint('Card tapped: $index');
                },
              ),
              const SizedBox(height: 24),

              if (hasFibreOrderCompleted) ...[
                ActionButtons(
                  onClaimPressed: _navigateToClaim,
                  onTestConnectionPressed: _testConnection,
                ),
                const SizedBox(height: 24),
              ],

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
    );
  }
}
