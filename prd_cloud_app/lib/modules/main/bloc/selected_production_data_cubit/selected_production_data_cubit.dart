import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';

part 'selected_production_data_state.dart';

class SelectedProductionDataCubit extends Cubit<int?> {
  SelectedProductionDataCubit() : super(null);

  selectProductionData(int id) {
    emit(id);
  }

  unselectProductionData() {
    emit(null);
  }

}
