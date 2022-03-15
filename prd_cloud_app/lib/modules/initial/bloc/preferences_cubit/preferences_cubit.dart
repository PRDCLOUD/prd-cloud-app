import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_preferences_repository/user_preferences_repository.dart';

part 'preferences_state.dart';

class PreferencesCubit extends Cubit<UserPreferencesState> {
  PreferencesCubit({
    required UserPreferencesRepository tenant, 
    required List<String> selectedProductionLine
  }) : super(const UserPreferencesUnloaded());

  updateSelectedProductionLines(List<String> selectedProductionLine) {
    emit(state.copyWith(selectedProductionLines: selectedProductionLine));
  }


}
