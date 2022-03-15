import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

part 'stop_claim_state.dart';

class StopClaimCubit extends Cubit<StopClaimState> {
  StopClaimCubit({required List<StopClaim> stopClaims}) : super(StopClaimState(stopClaims: stopClaims));

  updateStopClaim(String claim, String? newValue) {
    var indexToChange = state.stopClaims.indexWhere((x) => x.claim == claim);
    var stopClaimToChange = state.stopClaims[indexToChange];

    var stopClaimChanged = stopClaimToChange.copyWith(claimValue: newValue);

    var newStopClaimsList = state.stopClaims.toList()..[indexToChange] = stopClaimChanged;
    emit(StopClaimState(stopClaims: newStopClaimsList));
  }
}
