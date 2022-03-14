import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:error_repository/error_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'production_stop_state.dart';

class ProductionStopCubit extends Cubit<ProductionStopState> {

  ProductionStopCubit({
    required ErrorRepository errorRepository,
    required OpenProductionDataRepository openProductionDataRepository,
    required int productionBasicDataId,
    required List<ProductionStop> initialValue
    }
  ) : 
    _errorRepository = errorRepository,
    super(ProductionStopState(
      productionBasicDataId: productionBasicDataId, 
      stops: initialValue, 
      status: ProductionStopStatus.updated
      )
    ) {
      _openProductionDataRepository = openProductionDataRepository;
      _openProductionDataRepository.openDataStream().listen(checkProductionDataAndUpdateLosses);
    }

  void checkProductionDataAndUpdateLosses(List<ProductionBasicData> items) {
    var prdData = items.firstWhere((element) => element.id == state.productionBasicDataId);
    if (state.stops != prdData.stops) {
      emit(state.copyWith(stops: prdData.stops));
    }
  }
  
  final ErrorRepository _errorRepository;
  late OpenProductionDataRepository _openProductionDataRepository;

  Future<bool> addStop({
    required int productionBasicDataId, 
    required int lineUnitId, 
    required int stopCurrentDefinitionId,
    required StopTypeOf stopType,
    required List<StopClaim> claims, 
    double? averageTimeAtStopQtyAverageTime, 
    int? qtyAtStopQtyAverageTime,
    DateTime? beginAtStopBeginAndTimeSpan,
    double? timeSpanAtStopBeginAndTimeSpan,
    DateTime? beginAtStopBeginEnd,
    DateTime? endAtStopBeginEnd,
    int? qtyAtStopQtyTotalTime,
    double? totalTimeAtStopQtyTotalTime,
    double? stopTimeAtStopTimePerStop
  }) async {

    emit(state.copyWith(status: ProductionStopStatus.adding));
    try {
      await _openProductionDataRepository.addStop(
        productionBasicDataId: productionBasicDataId,
        lineUnitId: lineUnitId,
        stopCurrentDefinitionId: stopCurrentDefinitionId,
        stopType: stopType,
        claims: claims,
        averageTimeAtStopQtyAverageTime: averageTimeAtStopQtyAverageTime,
        qtyAtStopQtyAverageTime: qtyAtStopQtyAverageTime,
        beginAtStopBeginAndTimeSpan: beginAtStopBeginAndTimeSpan,
        timeSpanAtStopBeginAndTimeSpan: timeSpanAtStopBeginAndTimeSpan,
        beginAtStopBeginEnd: beginAtStopBeginEnd,
        endAtStopBeginEnd: endAtStopBeginEnd,
        qtyAtStopQtyTotalTime: qtyAtStopQtyTotalTime,
        totalTimeAtStopQtyTotalTime: totalTimeAtStopQtyTotalTime,
        stopTimeAtStopTimePerStop: stopTimeAtStopTimePerStop
      );
      
      return true;
    } catch (e) {
      _errorRepository.communicateError(e);
      return false;
    } finally {
      emit(state.copyWith(status: ProductionStopStatus.updated));
    }
    
  }

  Future<void> removeStop(int productionBasicDataId, int productionStopId) async {
    emit(state.copyWith(status: ProductionStopStatus.deleting));
    try {
      await _openProductionDataRepository.deleteStop(productionBasicDataId, productionStopId);
    } catch (e) {
      _errorRepository.communicateError(e);
    } finally {
      emit(state.copyWith(status: ProductionStopStatus.updated));
    }
  }

}
