import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';

part 'selected_production_data_state.dart';

class SelectedProductionDataCubit extends Cubit<SelectedProductionDataState> {
  SelectedProductionDataCubit() : super(const SelectedProductionDataState(null));

  selectProductionData(ProductionBasicData productionBasicData) {
    emit(SelectedProductionDataState(productionBasicData));
  }

  unselectProductionData() {
    emit(const SelectedProductionDataState(null));
  }

}
