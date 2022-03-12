import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'open_production_data_state.dart';

class OpenProductionDataCubit extends Cubit<OpenProductionDataState> {
  OpenProductionDataCubit({required ProductionDataRepository productionDataRepository}) : _productionDataRepository = productionDataRepository, super(OpenProductionDataState.empty());

  final ProductionDataRepository _productionDataRepository;

  Future<ProductionBasicData?> loadProductionData(int id) async {

    if (state.loadingItem) return null;
    if (state.loadedItems.any((element) => element.id == id)) return null;

    try {
      emit(state.copyWith(loadingItem: true));

      var productionData = await _productionDataRepository.getApontamento(id);

      emit(state.copyWith(loadingItem: false, loadedItems: state.loadedItems..add(productionData)));      
      return productionData;
    } catch (e) {
      emit(state.copyWith(loadingItem: false));
      return null;
    }
  }

  void closeProductionData(int id) {
    var itemToRemove = state.loadedItems.firstWhere((x) => x.id == id);
    emit(state.copyWith(loadedItems: state.loadedItems..remove(itemToRemove)));
  }
}
