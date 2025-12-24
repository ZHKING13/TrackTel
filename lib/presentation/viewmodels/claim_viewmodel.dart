import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/claim_repository.dart';
import '../../data/repositories/claim_repository_impl.dart';
import '../../domain/entities/claim_entity.dart';
import '../../domain/usecases/submit_claim_usecase.dart';

class ClaimFormState {
  final ClaimReason? selectedReason;
  final String comment;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? errorMessage;
  final ClaimEntity? submittedClaim;

  const ClaimFormState({
    this.selectedReason,
    this.comment = '',
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.errorMessage,
    this.submittedClaim,
  });

  bool get isValid => selectedReason != null;

  ClaimFormState copyWith({
    ClaimReason? selectedReason,
    String? comment,
    bool? isSubmitting,
    bool? isSubmitted,
    String? errorMessage,
    ClaimEntity? submittedClaim,
    bool clearError = false,
    bool clearReason = false,
  }) {
    return ClaimFormState(
      selectedReason:
          clearReason ? null : (selectedReason ?? this.selectedReason),
      comment: comment ?? this.comment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      submittedClaim: submittedClaim ?? this.submittedClaim,
    );
  }
}

class ClaimFormNotifier extends StateNotifier<ClaimFormState> {
  final SubmitClaimUseCase _submitClaimUseCase;
  final String orderReference;

  ClaimFormNotifier({
    required SubmitClaimUseCase submitClaimUseCase,
    required this.orderReference,
  }) : _submitClaimUseCase = submitClaimUseCase,
       super(const ClaimFormState());

  void selectReason(ClaimReason? reason) {
    state = state.copyWith(selectedReason: reason, clearError: true);
  }

  void updateComment(String comment) {
    state = state.copyWith(comment: comment, clearError: true);
  }

  Future<bool> submitClaim() async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'Veuillez sélectionner un motif');
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final claim = await _submitClaimUseCase.call(
        orderReference: orderReference,
        reason: state.selectedReason!,
        comment: state.comment,
      );

      state = state.copyWith(
        isSubmitting: false,
        isSubmitted: true,
        submittedClaim: claim,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Erreur lors de la soumission: ${e.toString()}',
      );
      return false;
    }
  }

  void reset() {
    state = const ClaimFormState();
  }
}

final claimRepositoryProvider = Provider<ClaimRepository>((ref) {
  return ClaimRepositoryImpl();
});

final submitClaimUseCaseProvider = Provider<SubmitClaimUseCase>((ref) {
  return SubmitClaimUseCase(ref.read(claimRepositoryProvider));
});

final claimFormProvider =
    StateNotifierProvider.family<ClaimFormNotifier, ClaimFormState, String>((
      ref,
      orderReference,
    ) {
      return ClaimFormNotifier(
        submitClaimUseCase: ref.read(submitClaimUseCaseProvider),
        orderReference: orderReference,
      );
    });
