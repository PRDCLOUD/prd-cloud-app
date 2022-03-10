part of 'tenant_information_cubit.dart';

enum TenantInformationLoadState { loaded, loading, unloaded }

@immutable
abstract class TenantInformationState extends Equatable {

  final TenantInformationLoadState tenantInformationLoadState;

  const TenantInformationState(this.tenantInformationLoadState);

  @override
  List<Object> get props => [tenantInformationLoadState];
}

class TenantInformationUnloaded extends TenantInformationState {
  const TenantInformationUnloaded() 
    : super (TenantInformationLoadState.unloaded);
}

class TenantInformationLoading extends TenantInformationState {
  const TenantInformationLoading() 
    : super (TenantInformationLoadState.loading);
}

class TenantInformationLoaded extends TenantInformationState {

  final TenantInformation tenantInformation;

  const TenantInformationLoaded({ required this.tenantInformation })
    : super (TenantInformationLoadState.loaded);

  @override
  List<Object> get props => [tenantInformationLoadState, tenantInformation];
}