import 'dart:async';
import 'package:authentication_repository/src/model/auth_data.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {

  final _storage = new FlutterSecureStorage();
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final _controller = StreamController<AuthenticationStatus>();

  AuthData? _authData;

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn() async {

    final result = await _appAuth.authorizeAndExchangeCode(
                        AuthorizationTokenRequest(
                          '0oa6cklumdlz9CMnW4x7',
                          'cloud.prd.auth:/callback',
                          issuer: 'https://dev-701974.okta.com/oauth2/default',
                          scopes: ['openid', 'profile', 'email', 'offline_access'],
                        ),
                      );

    if (result != null) {
      _authData = new AuthData('', result.accessToken, result.accessTokenExpirationDateTime);
      await _storeRefreshToken('', result.refreshToken!);
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      logOut();
    }
   
  }

  void logOut() {
    _authData = null;
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> refreshToken() async {

    if (_authData != null) {
      final refreshToken = await _getRefreshToken(_authData!.userEmail);

      final result = await _appAuth.token(TokenRequest('0oa6cklumdlz9CMnW4x7', 'cloud.prd.auth:/callback',
                              issuer: 'https://dev-701974.okta.com/oauth2/default',
                              refreshToken: refreshToken,
                              scopes: ['openid','profile', 'email', 'offline_access', 'api']));

      if (result != null) {
        _authData = new AuthData('', result.accessToken, result.accessTokenExpirationDateTime);
        await _storeRefreshToken('', result.refreshToken!);
        _controller.add(AuthenticationStatus.authenticated);
      } else {
        logOut();
      }
    } else {
      logOut();
    }
  }

  Future<void> _storeRefreshToken(String user, String? refreshToken) async {
    if (refreshToken == null) {
      await _clearRefreshToken(user);
    } else {
      await _storage.write(key: "${user}_refresh_token", value: refreshToken);
    }
  }

  Future<void> _clearRefreshToken(String user) async {
    await _storage.delete(key: "${user}_refresh_token");
  }

  Future<String?> _getRefreshToken(String user) async {
    return await _storage.read(key: "${user}_refresh_token");
  }

  void dispose() => _controller.close();
}