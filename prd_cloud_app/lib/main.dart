import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'package:prd_cloud_app/app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/services.dart';

Future<void> mainWithConfig(Config config) async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight, DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) async {
    await SentryFlutter.init(
    (options) {
      options.release = config.release;
      options.dsn = 'https://75e15b22082f44e9a194b03b2728eb7f@o1173155.ingest.sentry.io/6268050';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () {
      runApp(App(
          config: config,
          authenticationRepository: AuthenticationRepository(config)
        ));
      });
    });
}