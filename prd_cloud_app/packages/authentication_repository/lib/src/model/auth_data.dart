class AuthData {

  final String userId;
  final String name;
  final String userEmail;
  final String accessToken;
  final DateTime expiration;
  final List<String> groups;

  AuthData({required this.userId, required this.userEmail, required this.name, required this.accessToken, required this.expiration, required this.groups});

}