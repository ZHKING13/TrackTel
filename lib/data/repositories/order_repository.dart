import '../../domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getOrders();

  Future<OrderEntity?> getOrderByReference(String reference);

  Future<List<OrderEntity>> getOrdersByStatus(OrderStatus status);

  Future<List<OrderEntity>> getOrdersByType(OrderType type);

  Future<List<OrderEntity>> getActiveOrders();

  Future<OrderEntity?> updateOrderProgress({
    required String reference,
    required int progress,
    OrderStatus? status,
  });

  Future<OrderEntity?> updateOrder(OrderEntity order);
}
