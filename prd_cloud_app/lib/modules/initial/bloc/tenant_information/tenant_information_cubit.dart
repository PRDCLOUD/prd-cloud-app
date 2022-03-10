import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';
import 'package:tenant_data_repository/tenant_data_repository.dart';

part 'tenant_information_state.dart';

class TenantInformationCubit extends Cubit<TenantInformationState> {
  TenantInformationCubit({required TenantDataRepository tenantDataRepository}) : _tenantDataRepository = tenantDataRepository, super(const TenantInformationUnloaded());

    final TenantDataRepository _tenantDataRepository;


    Future loadTenantInformation(Tenant tenant) async {
      emit(const TenantInformationLoading());
      var tenantInformationResponse = await _tenantDataRepository.getTenantInformation();
      var tenantInformation = TenantInformation.fromJson(tenantInformationResponse.data);
      emit(TenantInformationLoaded(tenantInformation: tenantInformation));
    }
    void unselectTenant() => emit(const TenantInformationUnloaded());

  @override
  Future<void> close() {
    return super.close();
  }

}
