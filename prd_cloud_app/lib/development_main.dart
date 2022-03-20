
import 'package:prd_cloud_app/config/config_development.dart';
import 'package:prd_cloud_app/main.dart';

Future<void> main() async {
  await mainWithConfig(DevelopmentEnvConfig());
}