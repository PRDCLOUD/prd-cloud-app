import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tenant_repository/tenant_repository.dart';

part 'tenant_options_state.dart';

class TenantOptionsCubit extends Cubit<TenantOptionsState> {
  TenantOptionsCubit({required AuthenticationRepository authenticationRepository}) : _authenticationRepository = authenticationRepository, super(const TenantOptionsState([])) {
    _authDataSubscription = _authenticationRepository.authData.listen(authDataChanged);
  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthData?> _authDataSubscription;

  void authDataChanged(AuthData? authData) => emit(TenantOptionsState(authData?.groups.map((group) => Tenant(group)) ?? []));

  @override
  Future<void> close() {
    _authDataSubscription.cancel();
    return super.close();
  }

}
