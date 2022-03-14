part of 'stop_claim_cubit.dart';

@immutable
class StopClaimState extends Equatable {

  final List<StopClaim> stopClaims;

  const StopClaimState({required this.stopClaims});
  
  @override
  List<Object?> get props => [stopClaims];

  bool isStopClaimFillValid() {
    return !stopClaims.any((e) => e.required && (e.claimValue == null || e.claimValue!.trim() == ''));
  }
}
