import 'package:equatable/equatable.dart';

import '../models.dart';

class ApiConnectionData extends Equatable {


  final Tenant tenant;
  final String authority;
  final Future<String> Function() getAccessToken;

  ApiConnectionData(this.authority, this.tenant, this.getAccessToken);


  @override
  List<Object> get props => [tenant, authority, getAccessToken];
}
