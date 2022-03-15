import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:error_repository/error_repository.dart';
import 'package:flutter/material.dart';
import 'package:user_preferences_repository/user_preferences_repository.dart';

part 'user_preferences_state.dart';

class UserPreferencesCubit extends Cubit<UserPreferencesState> {
  UserPreferencesCubit({
    required List<String> selectedProductionLines,
    required UserPreferencesRepository userPreferencesRepository,
    required ErrorRepository errorRepository
  }) : _userPreferencesRepository= userPreferencesRepository, _errorRepository = errorRepository, super(UserPreferencesState(selectedProductionLines: selectedProductionLines));

  final UserPreferencesRepository _userPreferencesRepository;
  final ErrorRepository _errorRepository;

  updateSelectedProductionLines(List<String> selectedProductionLine) {
    emit(state.copyWith(selectedProductionLines: selectedProductionLine));
    unawaited(_setProductionLine(selectedProductionLine));
  }

  Future<void> _setProductionLine(List<String> selectedProductionLine) async {
    try {
      _userPreferencesRepository.setSelectedProductionLine(selectedProductionLine);
    } catch (e) {
      _errorRepository.communicateError(e);
    }
  }


}
