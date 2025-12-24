import '../../data/repositories/order_repository.dart';
import '../entities/order_entity.dart';

/// Use case pour récupérer toutes les commandes
class GetOrdersUseCase {
  final OrderRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<List<OrderEntity>> call() async {
    return await _repository.getOrders();
  }
}
