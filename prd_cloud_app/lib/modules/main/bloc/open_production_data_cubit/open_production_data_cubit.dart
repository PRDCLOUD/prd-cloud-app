import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'open_production_data_state.dart';

class OpenProductionDataCubit extends Cubit<OpenProductionDataState> {
  OpenProductionDataCubit({required ProductionDataRepository productionDataRepository}) : _productionDataRepository = productionDataRepository, super(OpenProductionDataState.empty());

  final ProductionDataRepository _productionDataRepository;

  Future loadProductionData(int id) async {

    if (state.loadingItem) return;
    if (state.loadedItems.any((element) => element.id == id)) return;

    try {
      emit(state.copyWith(loadingItem: true, selectedItem: state.selectedItem));

      var productionData = await _productionDataRepository.getApontamento(id);

      emit(state.copyWith(loadingItem: false, loadedItems: state.loadedItems..add(productionData), selectedItem: productionData));      
    } catch (e) {
      emit(state.copyWith(loadingItem: false, selectedItem: state.selectedItem));
    }
  }

  selectProductionData(int id) {
    var selectedItem = state.loadedItems.firstWhere((x) => x.id == id);
    emit(state.copyWith(selectedItem: selectedItem));
  }

  void closeProductionData(int id) {
    var itemToRemove = state.loadedItems.firstWhere((x) => x.id == id);
    ProductionBasicData? nextItemToSelect = state.selectedItem;
    if (itemToRemove == state.selectedItem) {
      if (state.loadedItems.length > 1) {
        nextItemToSelect = state.loadedItems.firstWhere((element) => element != state.selectedItem);
      } else {
        nextItemToSelect = null;
      }
    } 
    emit(state.copyWith(loadedItems: state.loadedItems..remove(itemToRemove), selectedItem: nextItemToSelect));
  }
}
