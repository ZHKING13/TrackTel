import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/get_order_by_reference_usecase.dart';
import '../../domain/usecases/update_order_progress_usecase.dart';

class OrdersState {
  final List<OrderEntity> orders;
  final bool isLoading;
  final String? errorMessage;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  OrdersState copyWith({
    List<OrderEntity>? orders,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class OrdersNotifier extends StateNotifier<OrdersState> {
  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrderByReferenceUseCase _getOrderByReferenceUseCase;
  final UpdateOrderProgressUseCase _updateOrderProgressUseCase;

  OrdersNotifier({
    required GetOrdersUseCase getOrdersUseCase,
    required GetOrderByReferenceUseCase getOrderByReferenceUseCase,
    required UpdateOrderProgressUseCase updateOrderProgressUseCase,
  }) : _getOrdersUseCase = getOrdersUseCase,
       _getOrderByReferenceUseCase = getOrderByReferenceUseCase,
       _updateOrderProgressUseCase = updateOrderProgressUseCase,
       super(const OrdersState());

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final orders = await _getOrdersUseCase();
      state = state.copyWith(orders: orders, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement des commandes: $e',
      );
    }
  }

  Future<OrderEntity?> getOrderByReference(String reference) async {
    try {
      return await _getOrderByReferenceUseCase(reference);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erreur lors de la récupération de la commande: $e',
      );
      return null;
    }
  }

  Future<void> updateOrderProgress({
    required String reference,
    required int progress,
    OrderStatus? status,
  }) async {
    try {
      final updatedOrder = await _updateOrderProgressUseCase(
        reference: reference,
        progress: progress,
        status: status,
      );

      if (updatedOrder != null) {
        final updatedOrders =
            state.orders.map((order) {
              if (order.reference == reference) {
                return updatedOrder;
              }
              return order;
            }).toList();

        state = state.copyWith(orders: updatedOrders);
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erreur lors de la mise à jour de la commande: $e',
      );
    }
  }

  List<OrderEntity> get activeOrders {
    return state.orders
        .where(
          (order) =>
              order.status == OrderStatus.inProgress ||
              order.status == OrderStatus.pending,
        )
        .toList();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}


final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl();
});

final getOrdersUseCaseProvider = Provider<GetOrdersUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetOrdersUseCase(repository);
});

final getOrderByReferenceUseCaseProvider = Provider<GetOrderByReferenceUseCase>(
  (ref) {
    final repository = ref.watch(orderRepositoryProvider);
    return GetOrderByReferenceUseCase(repository);
  },
);

final updateOrderProgressUseCaseProvider = Provider<UpdateOrderProgressUseCase>(
  (ref) {
    final repository = ref.watch(orderRepositoryProvider);
    return UpdateOrderProgressUseCase(repository);
  },
);

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((
  ref,
) {
  return OrdersNotifier(
    getOrdersUseCase: ref.watch(getOrdersUseCaseProvider),
    getOrderByReferenceUseCase: ref.watch(getOrderByReferenceUseCaseProvider),
    updateOrderProgressUseCase: ref.watch(updateOrderProgressUseCaseProvider),
  );
});
