part of 'tenant_selection_bloc.dart';

class TenantSelectionState extends Equatable {

  final Tenant tenant;

  const TenantSelectionState._({ this.tenant = Tenant.empty });

  const TenantSelectionState.unselected()
      : this._();

  const TenantSelectionState.selected(Tenant tenant)
      : this._(tenant: tenant);

  @override
  List<Object> get props => [tenant];
}