import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'field_variable_numeric_state.dart';

class FieldVariableNumericCubit extends Cubit<FieldVariableNumericState> {
  FieldVariableNumericCubit({
    required OpenProductionDataRepository openProductionDataRepository, 
    required int productionBasicDataId, 
    required int variableDataId,
    required String label, 
    required bool enabled,
    required int decimals,
    required double? initialValue,
  }) : _openProductionDataRepository = openProductionDataRepository, 
  super(FieldVariableNumericState(
    productionBasicDataId: productionBasicDataId, 
    variableDataId: variableDataId, 
    enabled: enabled, 
    label: label, 
    decimals: decimals, 
    fieldValue: initialValue)
  );

  final OpenProductionDataRepository _openProductionDataRepository;

  void updateField(double? newValue) {
    _openProductionDataRepository.updateVariableNumeric(state.productionBasicDataId, state.variableDataId, newValue);
    emit(state.newFieldValue(newValue));
  }

}
