import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'open_production_data_state.dart';

class OpenProductionDataCubit extends Cubit<OpenProductionDataState> {
  OpenProductionDataCubit({required ProductionDataRepository productionDataRepository}) : _productionDataRepository = productionDataRepository, super(OpenProductionDataState.empty());

  final List<ProductionBasicData> items = List.empty();
  final ProductionDataRepository _productionDataRepository;

  Future insertProductionData(int id) async {
    if (!items.any((element) => element.id == id)) {
      var productionData = await _productionDataRepository.getApontamento(id);
      _addItem(productionData);
    }  
  }

  void closeProductionData(int id) {
    var itemToRemove = items.firstWhere((x) => x.id == id);
    _removeItem(itemToRemove);
  }

  void _addItem(ProductionBasicData item) {
    items.add(item);
    emit(state.copyWith(items: items));
  }

  void _removeItem(ProductionBasicData item) {
    items.remove(item);
    emit(state.copyWith(items: items));
  }

}
