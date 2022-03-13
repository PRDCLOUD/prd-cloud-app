import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'production_stop_state.dart';

class ProductionStopCubit extends Cubit<ProductionStopState> {

  ProductionStopCubit({
    required OpenProductionDataRepository openProductionDataRepository,
    required int productionBasicDataId,
    required List<ProductionStop> initialValue
    }
  ) : 
    super(ProductionStopState(
      productionBasicDataId: productionBasicDataId, 
      stops: initialValue, 
      status: ProductionStopStatus.updated
      )
    ) {
      _openProductionDataRepository = openProductionDataRepository;
      _openProductionDataRepository.openDataStream().listen(checkProductionDataAndUpdateLosses);
    }

  void checkProductionDataAndUpdateLosses(items) {
    var prdData = items.firstWhere((element) => element.id == state.productionBasicDataId);
    if (state.stops != prdData.stops) {
      emit(state.copyWith(stops: prdData.stops));
    }
  }
  

  late OpenProductionDataRepository _openProductionDataRepository;

  Future<bool> addStop(int productionBasicDataId, int lossCurrentDefinitionId, double lossValue, int lineUnitId) async {
    emit(state.copyWith(status: ProductionStopStatus.adding));
    var result = await _openProductionDataRepository.addLoss(productionBasicDataId, lossCurrentDefinitionId, lossValue, lineUnitId);
    emit(state.copyWith(status: ProductionStopStatus.updated));
    return result;
  }

  Future<void> removeStop(int productionBasicDataId, int productionStopId) async {
    emit(state.copyWith(status: ProductionStopStatus.deleting));
    await _openProductionDataRepository.deleteLoss(productionBasicDataId, productionStopId);
    emit(state.copyWith(status: ProductionStopStatus.updated));
  }

}
