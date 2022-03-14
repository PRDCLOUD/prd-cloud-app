import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:error_repository/error_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';

part 'open_production_data_state.dart';

class OpenProductionDataCubit extends Cubit<OpenProductionDataState> {
  OpenProductionDataCubit({
    required OpenProductionDataRepository openProductionDataRepository,
    required ErrorRepository errorRepository
  }) : 
    
    _openProductionDataRepository = openProductionDataRepository, 
    _errorRespository = errorRepository,
    super(OpenProductionDataState.empty()) {
    _openProductionDataRepository.openDataStream().listen((items) {
      emit(state.copyWith(loadedItems: items));
    });
  }

  final ErrorRepository _errorRespository;
  final OpenProductionDataRepository _openProductionDataRepository;

  

  Future loadProductionData(int id) async {

    if (state.loadingItem) return null;
    if (state.loadedItems.any((element) => element.id == id)) return null;

    try {
      emit(state.copyWith(loadingItem: true));
      
      try {
        await _openProductionDataRepository.loadProductionData(id); 
      } catch (e) {
        _errorRespository.communicateError(e);
      }

    } catch (e) {
      return null;
    } finally {
      emit(state.copyWith(loadingItem: false));
    }
  }

  void closeProductionData(int id) {
    var itemToRemove = state.loadedItems.firstWhere((x) => x.id == id);
    emit(state.copyWith(loadedItems: state.loadedItems..remove(itemToRemove)));
  }
}
