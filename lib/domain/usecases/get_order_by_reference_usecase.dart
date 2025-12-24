import '../../data/repositories/order_repository.dart';
import '../entities/order_entity.dart';

/// Use case pour récupérer une commande par sa référence
class GetOrderByReferenceUseCase {
  final OrderRepository _repository;

  GetOrderByReferenceUseCase(this._repository);

  Future<OrderEntity?> call(String reference) async {
    return await _repository.getOrderByReference(reference);
  }
}
