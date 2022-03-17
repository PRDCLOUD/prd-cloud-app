import 'package:error_repository/error_repository.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'production_data_state.dart';

class ProductionDataCubit extends Cubit<ProductionDataState> {
  ProductionDataCubit({
    required ProductionDataRepository apontamentosRepository,
    required ErrorRepository errorRepository
  }) : 
    _apontamentosRepository = apontamentosRepository, 
    _errorRepository = errorRepository,  
  super(ProductionDataState.notLoaded());

  final ErrorRepository _errorRepository;
  final ProductionDataRepository _apontamentosRepository;

  Future<void> refresh() async {
    if (state.status == ProductionDataLoadState.loading) return;
    if (state.filter == null) return;

    emit(ProductionDataState.loading(state.filter!));
    try {
      var result = await _apontamentosRepository.getApontamentos(state.filter!);
      emit(ProductionDataState.loaded(state.filter!, result));
    } catch(e) {
      _errorRepository.communicateError(e);
      emit(ProductionDataState.notLoaded());
    }
  }

  void filter(ProductionDataFilter filter) async {
    if (state.status == ProductionDataLoadState.loading) return;

    emit(ProductionDataState.loading(filter));
    try {
      var result = await _apontamentosRepository.getApontamentos(filter);
      emit(ProductionDataState.loaded(filter, result));
    } catch(e) {
      _errorRepository.communicateError(e);
      emit(ProductionDataState.notLoaded());
    }
  }

  Future<void> cancelItem(int id) async {
    if (state.status == ProductionDataLoadState.loading) return;

    emit(ProductionDataState.loading(state.filter!, state.loadedResult));
    try {
      await _apontamentosRepository.cancelApontamento(id);
      var newResultList  = state.loadedResult.toList()..removeWhere((element) => element.id == id && element.status != ProductionDataStatus.canceled);
      emit(ProductionDataState.loaded(state.filter!, newResultList));
    } catch(e) {
      _errorRepository.communicateError(e);
      emit(ProductionDataState.loaded(state.filter!, state.loadedResult));
    }
  }

  Future<bool> reOpenItem(int id) async {
    if (state.status == ProductionDataLoadState.loading) return false;

    emit(ProductionDataState.loading(state.filter!, state.loadedResult));
    try {
      await _apontamentosRepository.reopenApontamento(id);
      var newResultList  = state.loadedResult.toList()..removeWhere((element) => element.id == id && element.status != ProductionDataStatus.opened);
      emit(ProductionDataState.loaded(state.filter!, newResultList));
      return true;
    } catch(e) {
      _errorRepository.communicateError(e);
      emit(ProductionDataState.loaded(state.filter!, state.loadedResult));
      return false;
    }
  }

}
