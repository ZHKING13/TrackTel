import '../../data/repositories/order_repository.dart';
import '../entities/order_entity.dart';

class UpdateOrderProgressUseCase {
  final OrderRepository _repository;

  UpdateOrderProgressUseCase(this._repository);

  Future<OrderEntity?> call({
    required String reference,
    required int progress,
    OrderStatus? status,
  }) async {
    return await _repository.updateOrderProgress(
      reference: reference,
      progress: progress,
      status: status,
    );
  }
}
