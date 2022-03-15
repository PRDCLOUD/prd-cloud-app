import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'field_end_state.dart';

class FieldEndCubit extends Cubit<FieldEndState> {
  FieldEndCubit({
    required OpenProductionDataRepository openProductionDataRepository, 
    required int productionBasicDataId, 
    required DateTime? initialValue,
  }) : _openProductionDataRepository = openProductionDataRepository, super(FieldEndState(productionBasicDataId: productionBasicDataId, fieldValue: initialValue));

  final OpenProductionDataRepository _openProductionDataRepository;

  updateField(DateTime? newValue) {
    _openProductionDataRepository.updateEnd(state.productionBasicDataId, newValue);
    emit(state.copyWith(fieldValue: newValue));
  }

}
