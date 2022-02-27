class AuthData {

  final String userEmail;
  final String? accessToken;
  final DateTime? expiration;

  AuthData(this.userEmail, this.accessToken, this.expiration);

}