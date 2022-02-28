import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tenant_repository/tenant_repository.dart';

part 'tenant_selection_state.dart';

class TenantSelectionCubit extends Cubit<TenantSelectionState> {
  TenantSelectionCubit({required AuthenticationRepository authenticationRepository}) : _authenticationRepository = authenticationRepository, super(TenantUnselected()) {
    _authDataSubscription = _authenticationRepository.authData.listen(authDataChanged);
  }

    final AuthenticationRepository _authenticationRepository;
    late StreamSubscription<AuthData?> _authDataSubscription;

    void authDataChanged(AuthData? authData) {
      if (authData == null) {
        unselectTenant();
      } else if (authData.groups.length == 1) {
        selectTenant(Tenant(authData.groups.first));
      } else if (state is TenantSelectedState) {
        var selectedState = state as TenantSelectedState;
        if (!authData.groups.contains(selectedState.tenant.name)) {
          unselectTenant();
        }
      }
    }

    void selectTenant(Tenant tenant) => emit(TenantSelectedState.selected(tenant));
    void unselectTenant() => emit(TenantUnselected());

  @override
  Future<void> close() {
    _authDataSubscription.cancel();
    return super.close();
  }

}
