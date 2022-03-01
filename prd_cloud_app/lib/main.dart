import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:prd_cloud_app/app.dart';

void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepository()
  ));
}