import 'package:apontamentos_repository/apontamento_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'apontamentos_event.dart';
part 'apontamentos_state.dart';

class ApontamentosBloc extends Bloc<ApontamentosEvent, ApontamentosState> {
  ApontamentosBloc({required apontamentosRepository}) : _apontamentosRepository = apontamentosRepository,  super(ApontamentosState.notLoaded()) {
    on<ApontamentosRefreshEvent>(_onAuthenticationStatusChanged);
  }

  final ApontamentosRepository _apontamentosRepository;

  void _onAuthenticationStatusChanged(ApontamentosRefreshEvent event, Emitter<ApontamentosState> emit) async {
    emit(ApontamentosState.loading());
    var result = await _apontamentosRepository.getApontamentos(event.take);
    emit(ApontamentosState.loaded(result));
  }

}
