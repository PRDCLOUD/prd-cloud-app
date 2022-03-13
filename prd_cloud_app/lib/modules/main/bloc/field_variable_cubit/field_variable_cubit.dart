import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'field_variable_state.dart';

class FieldVariableCubit extends Cubit<FieldVariableState> {
  FieldVariableCubit({
    required OpenProductionDataRepository openProductionDataRepository, 
    required int productionBasicDataId, 
    required int variableDataId, 
    required int? initialValue,
  }) : _openProductionDataRepository = openProductionDataRepository, super(FieldVariableState(productionBasicDataId: productionBasicDataId, variableDataId: variableDataId, fieldValue: initialValue));

  final OpenProductionDataRepository _openProductionDataRepository;

  void updateField(int? newValue) {
    _openProductionDataRepository.updateProduct(state.productionBasicDataId, newValue);
    emit(state.copyWith(fieldValue: newValue));
  }

}
