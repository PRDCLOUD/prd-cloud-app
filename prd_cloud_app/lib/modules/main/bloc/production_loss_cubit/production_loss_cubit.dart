import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'production_loss_state.dart';

class ProductionLossCubit extends Cubit<ProductionLossState> {

  ProductionLossCubit({
    required OpenProductionDataRepository openProductionDataRepository,
    required int productionBasicDataId,
    required List<ProductionLoss> initialValue
    }
  ) : 
    super(ProductionLossState(
      productionBasicDataId: productionBasicDataId, 
      losses: initialValue, 
      status: ProductionLossStatus.updated
      )
    ) {
      _openProductionDataRepository = openProductionDataRepository;
      _openProductionDataRepository.openDataStream().listen(checkProductionDataAndUpdateLosses);
    }

  void checkProductionDataAndUpdateLosses(items) {
    var prdData = items.firstWhere((element) => element.id == state.productionBasicDataId);
    if (state.losses != prdData.losses) {
      emit(state.copyWith(losses: prdData.losses));
    }
  }
  

  late OpenProductionDataRepository _openProductionDataRepository;

  Future<bool> addLoss(int productionBasicDataId, int lossCurrentDefinitionId, double lossValue, int lineUnitId) async {
    emit(state.copyWith(status: ProductionLossStatus.adding));
    var result = await _openProductionDataRepository.addLoss(productionBasicDataId, lossCurrentDefinitionId, lossValue, lineUnitId);
    emit(state.copyWith(status: ProductionLossStatus.updated));
    return result;
  }

  Future<void> removeLoss(int productionBasicDataId, int productionLossId) async {
    emit(state.copyWith(status: ProductionLossStatus.deleting));
    await _openProductionDataRepository.deleteLoss(productionBasicDataId, productionLossId);
    emit(state.copyWith(status: ProductionLossStatus.updated));
  }

}
