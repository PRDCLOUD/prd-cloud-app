import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_connections/http_connections.dart';
import 'package:prd_cloud_app/modules/initial/bloc/tenant_information/tenant_information_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/tenant_selection/tenant_selection_cubit.dart';
import 'package:prd_cloud_app/modules/production_data/screens/production_data_list/production_data_list.dart';
import 'package:production_data_repository/production_data_repository.dart';
import 'package:tenant_data_repository/tenant_data_repository.dart';

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

    return MultiRepositoryProvider(providers: [
        RepositoryProvider(create: (context) => TenantDataRepository(httpConnections), lazy: false),
        RepositoryProvider(create: (context) => httpConnections)
      ], 
      child: MultiBlocProvider(providers: [
            BlocProvider(
              create: (context) => TenantInformationCubit(tenantDataRepository: context.read<TenantDataRepository>())..loadTenantInformation((context.read<TenantSelectionCubit>().state as TenantSelectedState).tenant),
              child: Container()
            )
          ], 
          child: const TenantInformationLoadingPage()
        )
      );
  }
}

class TenantInformationLoadingPage extends StatelessWidget {
  const TenantInformationLoadingPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TenantInformationCubit, TenantInformationState>(
      builder: (context, state) {
        switch (state.tenantInformationLoadState) {
          case TenantInformationLoadState.loaded: 
            return  const MainRepositoryProviderPage(child: ProductionDataListPage());
          case TenantInformationLoadState.loading:
            return const Scaffold(
                body: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("Loading Tenant Info", textAlign: TextAlign.center)
                )
            );
          case TenantInformationLoadState.unloaded:
            var tenantState = context.read<TenantSelectionCubit>().state as TenantSelectedState;
            context.read<TenantInformationCubit>().loadTenantInformation(tenantState.tenant);
            return const Scaffold(
                body: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("Unloaded Tenant Info", textAlign: TextAlign.center)
                )
            );
        }
        
      },
    );
  }
}


class MainRepositoryProviderPage extends StatelessWidget {
  const MainRepositoryProviderPage({ Key? key, required Widget child }) : _child = child, super(key: key);

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    var authenticatedHttpClient = context.read<AuthenticatedHttpClient>();
    var tenantInformation = (context.read<TenantInformationCubit>().state as TenantInformationLoaded).tenantInformation;
    return MultiRepositoryProvider(providers: [
            RepositoryProvider(create: (context) =>  ProductionDataRepository(authenticatedHttpClient, tenantInformation), lazy: false)
          ], 
          child: Builder(
            builder: (context) {
              return _child;
            }
          ));
  
  }
}
