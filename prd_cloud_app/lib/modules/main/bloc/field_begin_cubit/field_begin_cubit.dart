import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'field_begin_state.dart';

class FieldBeginCubit extends Cubit<FieldBeginState> {
  FieldBeginCubit({
    required OpenProductionDataRepository openProductionDataRepository, 
    required int productionBasicDataId, 
    required DateTime? initialValue,
  }) : _openProductionDataRepository = openProductionDataRepository, super(FieldBeginState(productionBasicDataId: productionBasicDataId, fieldValue: initialValue));

  final OpenProductionDataRepository _openProductionDataRepository;

  updateField(DateTime? newValue) {
    _openProductionDataRepository.updateBegin(state.productionBasicDataId, newValue);
    emit(state.copyWith(fieldValue: newValue));
  }

}
