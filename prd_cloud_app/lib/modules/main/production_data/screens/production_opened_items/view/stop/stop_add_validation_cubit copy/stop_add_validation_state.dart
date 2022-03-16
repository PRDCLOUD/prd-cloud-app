part of 'stop_add_validation_cubit.dart';

enum TimeValidation {valid, invalid}
enum ClaimValidation {valid, invalid}

@immutable
class StopAddValidationState extends Equatable {

  final TimeValidation timeValidation;
  final ClaimValidation claimValidation;

  const StopAddValidationState({required this.timeValidation, required this.claimValidation});

  @override
  List<Object> get props => [timeValidation, claimValidation];

  StopAddValidationState copyWith({
    TimeValidation? timeValidation,
    ClaimValidation? claimValidation,
  }) {
    return StopAddValidationState(
      timeValidation: timeValidation ?? this.timeValidation,
      claimValidation: claimValidation ?? this.claimValidation,
    );
  }
}
