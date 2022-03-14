import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:error_repository/error_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'production_loss_state.dart';

class ProductionLossCubit extends Cubit<ProductionLossState> {

  ProductionLossCubit({
    required ErrorRepository errorRepository,
    required OpenProductionDataRepository openProductionDataRepository,
    required int productionBasicDataId,
    required List<ProductionLoss> initialValue
    }
  ) : 
    _errorRepository = errorRepository,
    super(ProductionLossState(
      productionBasicDataId: productionBasicDataId, 
      losses: initialValue, 
      status: ProductionLossStatus.updated
      )
    ) {
      _openProductionDataRepository = openProductionDataRepository;
      _openProductionDataRepository.openDataStream().listen(checkProductionDataAndUpdateLosses);
    }

  void checkProductionDataAndUpdateLosses(List<ProductionBasicData> items) {
    var prdData = items.firstWhere((element) => element.id == state.productionBasicDataId);
    if (state.losses != prdData.stops) {
      emit(state.copyWith(losses: prdData.losses));
    }
  }
  
  final ErrorRepository _errorRepository;
  late OpenProductionDataRepository _openProductionDataRepository;

  Future<bool> addLoss(int productionBasicDataId, int lossCurrentDefinitionId, double lossValue, int lineUnitId) async {
    emit(state.copyWith(status: ProductionLossStatus.adding));
    try {
      await _openProductionDataRepository.addLoss(productionBasicDataId, lossCurrentDefinitionId, lossValue, lineUnitId);
      return true;
    } catch (e) {
      _errorRepository.communicateError(e);
      return false;
    } finally {
      emit(state.copyWith(status: ProductionLossStatus.updated));
    }
  }

  Future<void> removeLoss(int productionBasicDataId, int productionLossId) async {
    emit(state.copyWith(status: ProductionLossStatus.deleting));
    try {
      await _openProductionDataRepository.deleteLoss(productionBasicDataId, productionLossId);
    } catch (e) {
      _errorRepository.communicateError(e);
    } finally {
      emit(state.copyWith(status: ProductionLossStatus.updated));
    }
  }

}
