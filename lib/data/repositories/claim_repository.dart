import '../../domain/entities/claim_entity.dart';

abstract class ClaimRepository {
  Future<ClaimEntity> submitClaim(ClaimEntity claim);

  Future<List<ClaimEntity>> getClaimsByOrder(String orderReference);

  Future<List<ClaimEntity>> getAllClaims();
}
