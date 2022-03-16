import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';

import 'package:prd_cloud_app/app.dart';
import 'package:timezone/data/latest.dart' as tz;
 import 'package:flutter/services.dart';

void main() {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight, DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_){
    runApp(App(
      authenticationRepository: AuthenticationRepository()
    ));
  });
}