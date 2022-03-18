import 'dart:async';
import 'dart:convert';
import 'package:authentication_repository/src/model/auth_data.dart';
import 'package:authentication_repository/src/utils/jwt-parser.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:models/models.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {

  AuthenticationRepository(Config config) {
    issuer = config.authIssuer;
    clientId = config.authClientId;
    redirectUrl = config.authRedirectUrl;
  }

  late String issuer;
  late String clientId;
  late String redirectUrl;

  final _storage = new FlutterSecureStorage();
  final _statusController = StreamController<AuthenticationStatus>();
  final _authDataController = StreamController<AuthData?>.broadcast();
    
  AuthData? _authData;

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unknown;
    yield* _statusController.stream;
  }

  Stream<AuthData?> get authData async* {
    yield null;
    yield* _authDataController.stream;
  }

  Future<void> logIn() async {
    final FlutterAppAuth _appAuth = FlutterAppAuth();
    final result = await _appAuth.authorizeAndExchangeCode(
                        AuthorizationTokenRequest(
                          clientId,
                          redirectUrl,
                          issuer: issuer,
                          scopes: ['openid', 'profile', 'email', 'offline_access'],
                        ),
                      );

      

    if (result != null) {
      var claims = JWT.parse(result.idToken!);

      _authData = new AuthData(
        userId: claims['sub'],
        userEmail: claims['email'],
        name: claims['name'],
        accessToken: result.accessToken!,
        expiration: result.accessTokenExpirationDateTime!,
        groups: (claims['groups'] as List<dynamic>).map((x) => x.toString()).toList()
      );
      await _storeRefreshToken(result.refreshToken!);
      _authDataController.add(_authData);
      _statusController.add(AuthenticationStatus.authenticated);
    } else {
      logOut();
    }
   
  }

  void logOut() {
    _authData = null;
    _clearRefreshToken();
    _authDataController.add(null);
    _statusController.add(AuthenticationStatus.unauthenticated);
  }

  Future<bool> refreshToken() async {

    final refreshToken = await _getRefreshToken();

    if (refreshToken == null) {
      logOut();
      return false;
    }

    Map<String, dynamic> body = {
      'grant_type': 'refresh_token', 
      'scope': 'openid profile email offline_access',
      'refresh_token': refreshToken,
      'client_id': clientId
    };
        
    var response = await http.post(
                      Uri.parse('${issuer}/v1/token'),
                      headers: {
                        'accept': 'application/json',
                        'Content-Type': 'application/x-www-form-urlencoded'
                      },
                      body: body,
                      encoding: Encoding.getByName('utf-8')
                    );
    

    if (response.statusCode != 200) {
      logOut();
      return false;
    }

    var result = json.decode(response.body);

    var idTokenClaims = JWT.parse(result['id_token']);

    _authData = new AuthData(
                  userId: idTokenClaims['sub'],
                  userEmail: idTokenClaims['sub'],
                  name: idTokenClaims['name'],
                  accessToken: result['access_token'],
                  expiration: DateTime.now().add(Duration(seconds: result['expires_in'] as int)).subtract(Duration(minutes: 5)),
                  groups: (idTokenClaims['groups'] as List<dynamic>).map((x) => x.toString()).toList()
                );

    await _storeRefreshToken(result['refresh_token'] as String);
    _authDataController.add(_authData);
    _statusController.add(AuthenticationStatus.authenticated);
    return true;
  }

  Future<String> getAccessToken() async {
    
    if (_authData == null) {
      logOut();
    }

    if (_authData!.expiration.isBefore(DateTime.now())) {
      await refreshToken();
    }
      
    return _authData!.accessToken;
    
  }

  Future<void> _storeRefreshToken(String? refreshToken) async {
    if (refreshToken == null) {
      await _clearRefreshToken();
    } else {
      await _storage.write(key: "refresh_token", value: refreshToken);
    }
  }

  Future<void> _clearRefreshToken() async {
    await _storage.delete(key: "refresh_token");
  }

  Future<String?> _getRefreshToken() async {
    return await _storage.read(key: "refresh_token");
  }

  void dispose() {
    _statusController.close();
    _authDataController.close();
  }
    
}