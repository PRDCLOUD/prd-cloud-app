import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'package:prd_cloud_app/app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/services.dart';

void mainWithConfig(Config config) {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight, DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_){
    runApp(App(
      config: config,
      authenticationRepository: AuthenticationRepository(config)
    ));
  });
}