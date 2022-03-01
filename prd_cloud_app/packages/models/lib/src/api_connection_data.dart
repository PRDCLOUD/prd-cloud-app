class ApiConnectionData {


  final String authority;
  final String Function() getAccessToken;

  ApiConnectionData(this.authority, this.getAccessToken);

}