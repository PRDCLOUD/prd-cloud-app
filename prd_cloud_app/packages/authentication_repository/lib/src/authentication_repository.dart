import 'dart:async';
import 'package:flutter_appauth/flutter_appauth.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {

  final FlutterAppAuth appAuth = FlutterAppAuth();
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn() async {

    final result = await appAuth.authorizeAndExchangeCode(
                        AuthorizationTokenRequest(
                          '0oa6cklumdlz9CMnW4x7',
                          'cloud.prd.auth:/callback',
                          issuer: 'https://dev-701974.okta.com/oauth2/default',
                          scopes: ['openid', 'profile', 'email', 'offline_access'],
                        ),
                      );

    _controller.add(AuthenticationStatus.authenticated);
    
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}