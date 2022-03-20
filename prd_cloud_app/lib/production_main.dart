import 'package:prd_cloud_app/config/config_production.dart';
import 'package:prd_cloud_app/main.dart';

Future<void> main() async {
  await mainWithConfig(ProductionEnvConfig());
}