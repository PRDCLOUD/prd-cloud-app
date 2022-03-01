class ApiConnectionData {


  final String tenant;
  final String authority;
  final String Function() getAccessToken;

  ApiConnectionData(this.authority, this.tenant, this.getAccessToken);

}