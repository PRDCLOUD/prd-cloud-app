import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'field_comments_state.dart';

class FieldCommentsCubit extends Cubit<FieldCommentsState> {
  FieldCommentsCubit({
    required OpenProductionDataRepository openProductionDataRepository, 
    required int productionGroupId, 
    required String? initialValue,
  }) : _openProductionDataRepository = openProductionDataRepository, super(FieldCommentsState(productionBasicDataId: productionGroupId, fieldValue: initialValue));

  final OpenProductionDataRepository _openProductionDataRepository;

  updateField(String? newValue) {
    _openProductionDataRepository.updateComments(state.productionBasicDataId, newValue);
    emit(state.copyWith(fieldValue: newValue));
  }

}
