import '../../domain/entities/claim_entity.dart';
import 'claim_repository.dart';

class ClaimRepositoryImpl implements ClaimRepository {
  final List<ClaimEntity> _claims = [];

  @override
  Future<ClaimEntity> submitClaim(ClaimEntity claim) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newClaim = claim.copyWith(
      id: 'CLM-${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    _claims.add(newClaim);

    print(' Nouvelle réclamation soumise:');
    print('   ID: ${newClaim.id}');
    print('   Commande: ${newClaim.orderReference}');
    print('   Motif: ${newClaim.reasonLabel}');
    print('   Commentaire: ${newClaim.comment}');

    return newClaim;
  }

  @override
  Future<List<ClaimEntity>> getClaimsByOrder(String orderReference) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _claims
        .where((claim) => claim.orderReference == orderReference)
        .toList();
  }

  @override
  Future<List<ClaimEntity>> getAllClaims() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_claims);
  }
}
