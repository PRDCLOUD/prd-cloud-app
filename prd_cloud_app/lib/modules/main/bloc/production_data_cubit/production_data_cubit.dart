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
      emit(ProductionDataState.loaded(result, state.filter!));
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
      emit(ProductionDataState.loaded(result, filter));
    } catch(e) {
      _errorRepository.communicateError(e);
      emit(ProductionDataState.notLoaded());
    }
  }

}
