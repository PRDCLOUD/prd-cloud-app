import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_connections/http_connections.dart';
import 'package:prd_cloud_app/modules/initial/bloc/tenant_selection/cubit/tenant_selection_cubit.dart';
import 'package:prd_cloud_app/modules/production_data/production_data_list/production_data_list.dart';
import 'package:production_data_repository/production_data_repository.dart';

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
          create: (context) => ProductionDataRepository(httpConnections),
        )
      ],
      child: const ProductionDataListPage()
    );

  }
}
