import 'dart:async';

import 'models/models.dart';

class TenantRepository {
  
  final List<Tenant> _tenants;

  final _tenantController = StreamController<Tenant>();

  Stream<Tenant> get tenant async* {
    yield Tenant.empty;
    yield* _tenantController.stream;
  }

  TenantRepository(this._tenants) {
    if (this._tenants.length == 1) {
      _tenantController.add(_tenants.first);
    }
  }

  void setTenant(Tenant tenant) {
    if (_tenants.contains(tenant)) {
      _tenantController.add(tenant);
    }
  }

}