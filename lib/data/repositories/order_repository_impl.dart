import '../../domain/entities/order_entity.dart';
import '../mock/mock_data.dart';
import '../models/order_model.dart' as model;
import 'order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<List<OrderEntity>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.orders.map(_mapModelToEntity).toList();
  }

  @override
  Future<OrderEntity?> getOrderByReference(String reference) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final order = MockData.getOrderByReference(reference);
    return order != null ? _mapModelToEntity(order) : null;
  }

  @override
  Future<List<OrderEntity>> getOrdersByStatus(OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final mockStatus = _mapStatusToModel(status);
    return MockData.getOrdersByStatus(
      mockStatus,
    ).map(_mapModelToEntity).toList();
  }

  @override
  Future<List<OrderEntity>> getOrdersByType(OrderType type) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final mockType = _mapTypeToModel(type);
    return MockData.getOrdersByType(mockType).map(_mapModelToEntity).toList();
  }

  @override
  Future<List<OrderEntity>> getActiveOrders() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.getActiveOrders().map(_mapModelToEntity).toList();
  }

  @override
  Future<OrderEntity?> updateOrderProgress({
    required String reference,
    required int progress,
    OrderStatus? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    MockData.updateOrder(
      reference,
      progress: progress,
      status: status != null ? _mapStatusToModel(status) : null,
    );

    return getOrderByReference(reference);
  }

  @override
  Future<OrderEntity?> updateOrder(OrderEntity order) async {
    return updateOrderProgress(
      reference: order.reference,
      progress: order.progress,
      status: order.status,
    );
  }

  OrderEntity _mapModelToEntity(model.OrderModel orderModel) {
    return OrderEntity(
      reference: orderModel.reference,
      type: _mapTypeFromModel(orderModel.type),
      status: _mapStatusFromModel(orderModel.status),
      progress: orderModel.progress,
      createdAt: orderModel.createdAt,
      updatedAt: orderModel.updatedAt,
    );
  }

  model.OrderType _mapTypeToModel(OrderType type) {
    switch (type) {
      case OrderType.fibre:
        return model.OrderType.fibre;
      case OrderType.sim:
        return model.OrderType.sim;
      case OrderType.box:
        return model.OrderType.box;
      case OrderType.intervention:
        return model.OrderType.intervention;
    }
  }

  OrderType _mapTypeFromModel(model.OrderType modelType) {
    switch (modelType) {
      case model.OrderType.fibre:
        return OrderType.fibre;
      case model.OrderType.sim:
        return OrderType.sim;
      case model.OrderType.box:
        return OrderType.box;
      case model.OrderType.intervention:
        return OrderType.intervention;
    }
  }

  model.OrderStatus _mapStatusToModel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return model.OrderStatus.pending;
      case OrderStatus.inProgress:
        return model.OrderStatus.inProgress;
      case OrderStatus.completed:
        return model.OrderStatus.completed;
      case OrderStatus.cancelled:
        return model.OrderStatus.cancelled;
    }
  }

  OrderStatus _mapStatusFromModel(model.OrderStatus modelStatus) {
    switch (modelStatus) {
      case model.OrderStatus.pending:
        return OrderStatus.pending;
      case model.OrderStatus.inProgress:
        return OrderStatus.inProgress;
      case model.OrderStatus.completed:
        return OrderStatus.completed;
      case model.OrderStatus.cancelled:
        return OrderStatus.cancelled;
    }
  }
}

typedef MockOrderType = dynamic;
typedef MockOrderStatus = dynamic;
