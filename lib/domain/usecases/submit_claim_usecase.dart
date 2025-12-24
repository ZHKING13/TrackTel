import '../../data/repositories/claim_repository.dart';
import '../entities/claim_entity.dart';

class SubmitClaimUseCase {
  final ClaimRepository _repository;

  SubmitClaimUseCase(this._repository);

  Future<ClaimEntity> call({
    required String orderReference,
    required ClaimReason reason,
    required String comment,
  }) {
    final claim = ClaimEntity(
      orderReference: orderReference,
      reason: reason,
      comment: comment,
    );
    return _repository.submitClaim(claim);
  }
}
