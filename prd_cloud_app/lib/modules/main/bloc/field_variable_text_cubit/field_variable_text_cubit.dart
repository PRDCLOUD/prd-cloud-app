import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'field_variable_text_state.dart';

class FieldVariableTextCubit extends Cubit<FieldVariableTextState> {
  FieldVariableTextCubit({
    required OpenProductionDataRepository openProductionDataRepository, 
    required int productionBasicDataId, 
    required int variableDataId, 
    required String label,
    required String? initialValue,
  }) : _openProductionDataRepository = openProductionDataRepository, super(FieldVariableTextState(productionBasicDataId: productionBasicDataId, variableDataId: variableDataId, label: label, fieldValue: initialValue));

  final OpenProductionDataRepository _openProductionDataRepository;

  void updateField(String? newValue) {
    _openProductionDataRepository.updateVariableText(state.productionBasicDataId, state.variableDataId, newValue);
    emit(state.newFieldValue(newValue));
  }

}
