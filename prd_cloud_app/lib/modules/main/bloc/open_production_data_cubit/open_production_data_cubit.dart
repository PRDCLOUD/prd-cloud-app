import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:error_repository/error_repository.dart';
import 'package:flutter/material.dart';
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
    _openProductionDataSubscription = _openProductionDataRepository.openDataStream().listen((items) {
      emit(state.copyWith(loadedItems: items));
    });
  }

  final ErrorRepository _errorRespository;
  final OpenProductionDataRepository _openProductionDataRepository;
  late StreamSubscription<List<ProductionDataGroup>> _openProductionDataSubscription;

  Future openNewProductionData(List<ProductionLineAndGroup> productionLineAndGroups) async {
    if (state.loadingItem) return;

    try {
      emit(state.copyWith(loadingItem: true));
      
      try {
        await _openProductionDataRepository.openNewProductionData(productionLineAndGroups); 
      } catch (e) {
        _errorRespository.communicateError(e);
      }

    } catch (e) {
      return null;
    } finally {
      emit(state.copyWith(loadingItem: false));
    }
  }

  Future loadProductionData(int productionDataId) async {

    if (state.loadingItem) return null;
    if (state.loadedItems.any((group) => group.hasProductionData(productionDataId))) return null;

    try {
      emit(state.copyWith(loadingItem: true));
      
      try {
        await _openProductionDataRepository.loadProductionData(productionDataId); 
      } catch (e) {
        _errorRespository.communicateError(e);
      }

    } catch (e) {
      return null;
    } finally {
      emit(state.copyWith(loadingItem: false));
    }
  }

  Future concludeProductionData(int productionDataId) async {

    if (state.loadingItem) return null;
    if (!state.loadedItems.any((group) => group.hasProductionData(productionDataId))) return null;

    try {
      emit(state.copyWith(loadingItem: true));
      
      try {
        await _openProductionDataRepository.concludeProductionData(state.loadedItems.firstWhere((e) => e.hasProductionData(productionDataId)));
      } catch (e) {
        _errorRespository.communicateError(e);
      }

    } catch (e) {
      return null;
    } finally {
      emit(state.copyWith(loadingItem: false));
    }
  }

  Future cancelProductionData(int productionDataId) async {

    if (state.loadingItem) return null;
    if (!state.loadedItems.any((group) => group.hasProductionData(productionDataId))) return null;

    try {
      emit(state.copyWith(loadingItem: true));
      
      try {
        await _openProductionDataRepository.cancelProductionData(productionDataId); 
      } catch (e) {
        _errorRespository.communicateError(e);
      }

    } catch (e) {
      return null;
    } finally {
      emit(state.copyWith(loadingItem: false));
    }
  }

  void closeProductionData(int productionDataId) {
    _openProductionDataRepository.closeProductionData(productionDataId);
  }

  @override
  Future<void> close() {
    _openProductionDataSubscription.cancel();
    return super.close();
  }

}
