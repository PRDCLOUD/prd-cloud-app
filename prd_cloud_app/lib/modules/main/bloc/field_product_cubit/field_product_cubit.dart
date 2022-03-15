import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'field_product_state.dart';

class FieldProductCubit extends Cubit<FieldProductState> {
  FieldProductCubit({
    required OpenProductionDataRepository openProductionDataRepository, 
    required int productionBasicDataId, 
    required int? initialValue,
  }) : _openProductionDataRepository = openProductionDataRepository, super(FieldProductState(productionBasicDataId: productionBasicDataId, fieldValue: initialValue));

  final OpenProductionDataRepository _openProductionDataRepository;

  void updateField(int? newValue) {
    _openProductionDataRepository.updateProduct(state.productionBasicDataId, newValue);
    emit(state.copyWith(fieldValue: newValue));
  }

}
