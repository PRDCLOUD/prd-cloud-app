import 'package:models/models.dart';

class ProductionEnvConfig extends Config {
  @override
  final String apiDomain = 'prod-api-v15.prdcloud.net';
  @override
  final String authIssuer = 'https://dev-244599.oktapreview.com/oauth2/default';
  @override
  final String authClientId = '0oa15rgy0m4Y8k9Ik0h8';
  @override
  final String authRedirectUrl = 'cloud.prd.auth:/callback';
}


class DevelopemntEnvConfig extends Config {
  @override
  final String apiDomain = 'prod-api-v15.prdcloud.net';
  @override
  final String authIssuer = 'https://dev-244599.oktapreview.com/oauth2/default';
  @override
  final String authClientId = '0oa15rgy0m4Y8k9Ik0h8';
  @override
  final String authRedirectUrl = 'cloud.prd.auth:/callback';
}

