import '../models.dart';

class ApiConnectionData {


  final Tenant tenant;
  final String authority;
  final Future<String> Function() getAccessToken;

  ApiConnectionData(this.authority, this.tenant, this.getAccessToken);

}