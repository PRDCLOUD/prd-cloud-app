part of 'tenant_selection_cubit.dart';

@immutable
abstract class TenantSelectionState extends Equatable {

  @override
  List<Object> get props => [];
}

class TenantUnselected extends TenantSelectionState {}

class TenantSelectedState extends TenantSelectionState {

  final Tenant tenant;

  TenantSelectedState._({ this.tenant = Tenant.empty });

  TenantSelectedState.unselected()
      : this._();

  TenantSelectedState.selected(Tenant tenant)
      : this._(tenant: tenant);

  @override
  List<Object> get props => [tenant];
}