import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'stop_add_validation_state.dart';

class StopAddValidationCubit extends Cubit<StopAddValidationState> {
  StopAddValidationCubit({required bool isTimeValid, required bool isClaimValid}) 
  : super(StopAddValidationState(
    timeValidation:isTimeValid ? TimeValidation.valid : TimeValidation.invalid, 
    claimValidation: isClaimValid ? ClaimValidation.valid : ClaimValidation.invalid)
  );

  timeValidationState(bool isValid) {
    if (isValid) {
      emit(state.copyWith(timeValidation: TimeValidation.valid));
    } else {
      emit(state.copyWith(timeValidation: TimeValidation.invalid));
    }
  }

  claimValidationState(bool isValid) {
    if (isValid) {
      emit(state.copyWith(claimValidation: ClaimValidation.valid));
    } else {
      emit(state.copyWith(claimValidation: ClaimValidation.invalid));
    }
  }

}
