part of 'tenant_selection_bloc.dart';

abstract class TenantSelectionEvent extends Equatable {
  const TenantSelectionEvent();

  @override
  List<Object> get props => [];
}

class TenantSelectionChanged extends TenantSelectionEvent {
  const TenantSelectionChanged(this.tenant);

  final Tenant tenant;

  @override
  List<Object> get props => [tenant];
}

class TenantSelectionClear extends TenantSelectionEvent {}