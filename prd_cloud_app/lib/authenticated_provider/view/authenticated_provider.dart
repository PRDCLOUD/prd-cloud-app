import 'package:apontamentos_repository/apontamento_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_connections/http_connections.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/business_layer/apontamentos/bloc/apontamentos_bloc.dart';
import 'package:prd_cloud_app/business_layer/business_layer.dart';
import 'package:prd_cloud_app/home/home.dart';

class AuthenticatedProviderPage extends StatelessWidget {
  const AuthenticatedProviderPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const AuthenticatedProviderPage());
  }

  @override
  Widget build(BuildContext context) {
    var authenticationRepository = context.read<AuthenticationRepository>();
    var tenantSelection = context.read<TenantSelectionCubit>().state as TenantSelectedState;
    var httpConnections = AuthenticatedHttpClient('prod-api-v15.prdcloud.net', tenantSelection.tenant, authenticationRepository.getAccessToken);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ApontamentosRepository(httpConnections),
        )
      ],
      child: const HomePage()
    );

  }
}
