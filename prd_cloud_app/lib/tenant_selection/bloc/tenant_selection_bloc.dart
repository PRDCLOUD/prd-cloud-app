import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tenant_repository/tenant_repository.dart';

part 'tenant_selection_event.dart';
part 'tenant_selection_state.dart';

class TenantSelectionBloc extends Bloc<TenantSelectionEvent, TenantSelectionState> {
  TenantSelectionBloc({required AuthenticationRepository authenticationRepository}) 
    : _authenticationRepository = authenticationRepository, super(const TenantSelectionState.unselected()) {
    on<TenantSelectionChanged>(_onTenantChanged);
    on<TenantSelectionClear>(_onTenantClear);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onTenantChanged(TenantSelectionChanged event, Emitter<TenantSelectionState> emit) async {
    emit(TenantSelectionState.selected(event.tenant));
  }

  void _onTenantClear(TenantSelectionClear event, Emitter<TenantSelectionState> emit) async {
    emit(const TenantSelectionState.unselected());
  }
}
