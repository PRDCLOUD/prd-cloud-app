part of 'tenant_options_cubit.dart';


class TenantOptionsState extends Equatable {

  final Iterable<Tenant> tenants;

  const TenantOptionsState(this.tenants);

  @override
  List<Object> get props => [...tenants];
}