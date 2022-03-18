import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
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
  ) {
    productionDatastreamSubscription = _openProductionDataRepository.productionDataStream(productionBasicDataId).listen((productionData) {
      var currentVariableValue = productionData.lineUnits.expand((e) => e.lineUnit.productionVariables).firstWhere((e) => e.id == variableDataId);
      if (currentVariableValue.value != state.fieldValue) {
        emit(state.newFieldValue(currentVariableValue.value));
      }
    });
  }

  final OpenProductionDataRepository _openProductionDataRepository;
  late StreamSubscription<ProductionBasicData> productionDatastreamSubscription;

  void updateField(double? newValue) {
    _openProductionDataRepository.updateVariableNumeric(state.productionBasicDataId, state.variableDataId, newValue);
    emit(state.newFieldValue(newValue));
  }

  @override
  Future<void> close() {
    productionDatastreamSubscription.cancel();
    return super.close();
  }

}
