import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'field_variable_datetime_state.dart';

class FieldVariableDateTimeCubit extends Cubit<FieldVariableDateTimeState> {
  FieldVariableDateTimeCubit({
    required OpenProductionDataRepository openProductionDataRepository, 
    required int productionBasicDataId, 
    required int variableDataId, 
    required bool enabled,
    required bool required,
    required String label,
    required DateTimeType? dateTimeType,
    required DateTime? initialValue,
  }) : _openProductionDataRepository = openProductionDataRepository, 
    super(FieldVariableDateTimeState(
      productionBasicDataId: productionBasicDataId, 
      variableDataId: variableDataId, 
      label: label, 
      required: required,
      dateTimeType: dateTimeType, 
      fieldValue: initialValue, 
      enabled: enabled)
    );

  final OpenProductionDataRepository _openProductionDataRepository;

  void updateField(DateTime? newValue) {
    _openProductionDataRepository.updateVariableDateTime(state.productionBasicDataId, state.variableDataId, newValue);
    emit(state.newFieldValue(newValue));
  }

}
