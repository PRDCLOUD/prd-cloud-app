import 'package:error_repository/error_repository.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'production_data_event.dart';
part 'production_data_state.dart';

class ProductionDataBloc extends Bloc<ProductionDataEvent, ProductionDataState> {
  ProductionDataBloc({
    required ProductionDataRepository apontamentosRepository,
    required ErrorRepository errorRepository
  }) : 
    _apontamentosRepository = apontamentosRepository, 
    _errorRepository = errorRepository,  
  super(ProductionDataState.notLoaded()) {
    on<ApontamentosRefreshEvent>(_onAuthenticationStatusChanged);
  }

  final ErrorRepository _errorRepository;
  final ProductionDataRepository _apontamentosRepository;

  void _onAuthenticationStatusChanged(ApontamentosRefreshEvent event, Emitter<ProductionDataState> emit) async {
    emit(ProductionDataState.loading());
    try {
      var result = await _apontamentosRepository.getApontamentos(event.status, event.take, event.prdLines);
      emit(ProductionDataState.loaded(result));
    } catch(e) {
      _errorRepository.communicateError(e);
      emit(ProductionDataState.notLoaded());
    }
  }

}
