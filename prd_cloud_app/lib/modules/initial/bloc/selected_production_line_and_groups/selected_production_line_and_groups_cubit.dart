import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'selected_production_line_and_groups_state.dart';

class SelectedProductionLineAndGroupsCubit extends Cubit<SelectedProductionLineAndGroupsState> {
  
  SelectedProductionLineAndGroupsCubit(List<ProductionLineAndGroup> initialSelection) : super(SelectedProductionLineAndGroupsState(initialSelection));

    void select(ProductionLineAndGroup productionLineAndGroup) {
      if (!state.selectedProductionLinesAndGroups.contains(productionLineAndGroup)) {
        var newList = state.selectedProductionLinesAndGroups.toList()..add(productionLineAndGroup);
        emit(state.copyWith(selectedProductionLinesAndGroups: newList));
      }
    }

    void remove(ProductionLineAndGroup productionLineAndGroup) {
      var copyWithItemRemoved = state.selectedProductionLinesAndGroups.toList()..remove(productionLineAndGroup);
      emit(state.copyWith(selectedProductionLinesAndGroups: copyWithItemRemoved));
    }

  @override
  Future<void> close() {
    return super.close();
  }

}
