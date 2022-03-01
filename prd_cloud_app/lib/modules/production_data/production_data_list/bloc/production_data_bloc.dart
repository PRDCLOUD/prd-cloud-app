import 'package:production_data_repository/production_data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'production_data_event.dart';
part 'production_data_state.dart';

class ProductionDataBloc extends Bloc<ProductionDataEvent, ProductionDataState> {
  ProductionDataBloc({required apontamentosRepository}) : _apontamentosRepository = apontamentosRepository,  super(ProductionDataState.notLoaded()) {
    on<ApontamentosRefreshEvent>(_onAuthenticationStatusChanged);
  }

  final ProductionDataRepository _apontamentosRepository;

  void _onAuthenticationStatusChanged(ApontamentosRefreshEvent event, Emitter<ProductionDataState> emit) async {
    emit(ProductionDataState.loading());
    var result = await _apontamentosRepository.getApontamentos(event.take);
    emit(ProductionDataState.loaded(result));
  }

}
