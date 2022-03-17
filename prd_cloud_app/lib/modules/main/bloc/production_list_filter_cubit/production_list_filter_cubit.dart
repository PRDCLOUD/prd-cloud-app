import 'package:bloc/bloc.dart';
import 'package:models/models.dart';

class ProductionListFilterCubit extends Cubit<ProductionDataFilter> {
  ProductionListFilterCubit(ProductionDataFilter initialState) : super(initialState);

  markForRefresh() {
    emit(state.copyWith(filterKey: DateTime.now().toIso8601String()));
  }

  updateProductionLines(List<ProductionLineAndGroup> productionLineAndGroup) {
    emit(state.copyWith(prdLines: productionLineAndGroup.map((e) => e.id).toList()));
  }

  updateTake(int take) {
    emit(state.copyWith(take: take));
  }

  updateStatus(ProductionDataStatus status) {
    emit(state.copyWith(status: status));
  }

}
