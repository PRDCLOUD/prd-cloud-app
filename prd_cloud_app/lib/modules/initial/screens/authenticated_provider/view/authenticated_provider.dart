import 'package:authentication_repository/authentication_repository.dart';
import 'package:error_repository/error_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_connections/http_connections.dart';
import 'package:prd_cloud_app/modules/initial/bloc/auth_data_cubit/auth_data_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/production_line_and_groups/production_line_and_groups_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/selected_production_line_and_groups/selected_production_line_and_groups_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/tenant_information/tenant_information_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/tenant_selection/tenant_selection_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/user_preferences_cubit/user_preferences_cubit.dart';
import 'package:prd_cloud_app/modules/main/production_data/production_data_module.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';
import 'package:production_data_repository/production_data_repository.dart';
import 'package:tenant_data_repository/tenant_data_repository.dart';
import 'package:user_preferences_repository/user_preferences_repository.dart';

class AuthenticatedProviderPage extends StatelessWidget {
  const AuthenticatedProviderPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AuthenticatedProviderPage());
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
            return  const MainRepositoryProviderPage(
              child: MainBlocProvider(
                child: ProductionLineLoadingPage(
                  child: ProductionDataModule()
                )
              )
            );
          case TenantInformationLoadState.loading:
          case TenantInformationLoadState.unloaded:
            return const Scaffold(
              body: Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: Text("Carregando informações do cliente...", textAlign: TextAlign.center))
                )
              );
        }
      },
    );
  }
}

class MainBlocProvider extends StatefulWidget {
  const MainBlocProvider({ Key? key, required Widget child }) : _child = child, super(key: key);

  final Widget _child;

  @override
  State<MainBlocProvider> createState() => _MainBlocProviderState();
}

class _MainBlocProviderState extends State<MainBlocProvider> {

  Future<void> loadUserPreferences() async {
    var selectedProductionLines = await context.read<UserPreferencesRepository>().getSelectedProductionLine();
    setState(() {
      _selectedProductionLines = selectedProductionLines;
    });
  }

  List<String>? _selectedProductionLines;

  @override
  Widget build(BuildContext context) {
    if (_selectedProductionLines == null) {
      loadUserPreferences();
      return const LoadingScaffold(text: "Carregando preferências do usuário...");
    } else {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ProductionLineAndGroupsCubit(errorRepository: context.read(), productionLineRepository: context.read() ), lazy: false,),
          BlocProvider(
            create: (context) => UserPreferencesCubit(
              errorRepository: context.read(), 
              selectedProductionLines: _selectedProductionLines!,
              userPreferencesRepository: context.read()), 
            lazy: false,)
        ], 
        child: Builder(
          builder: (context) {
            return widget._child;
          }
        )
      );
    }

  }
}

class SelectedProductionLineAndGroupsProvider extends StatelessWidget {
  const SelectedProductionLineAndGroupsProvider({ Key? key, required Widget child }) : _child = child, super(key: key);

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductionLineAndGroupsCubit, ProductionLineAndGroupsState>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) => SelectedProductionLineAndGroupsCubit(List.empty()), lazy: false,
          child: Builder(
            builder: (context) {
              return _child;
            }
          )
        );
      },
    );
  }
}

class ProductionLineLoadingPage extends StatelessWidget {
  const ProductionLineLoadingPage({ Key? key, required Widget child }) : _child = child, super(key: key);

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductionLineAndGroupsCubit, ProductionLineAndGroupsState>(
      builder: (context, state) {
        switch (state.productionLineAndGroupsLoadState) {
          case ProductionLineAndGroupsLoadState.loaded: 
            return SelectedProductionLineAndGroupsProvider(child: _child);
          case ProductionLineAndGroupsLoadState.loading:
            return const LoadingScaffold(text: "Carregando linhas de produção...");
          case ProductionLineAndGroupsLoadState.unloaded:
            context.read<ProductionLineAndGroupsCubit>().loadProductionLines();
            return const LoadingScaffold(text: "Carregando linhas de produção...");
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
    var errorRepository = context.read<ErrorRepository>();
    return MultiRepositoryProvider(providers: [
            RepositoryProvider(create: (context) => ProductionLineRepository(authenticatedHttpClient), lazy: false,),
            RepositoryProvider(create: (context) => ProductionDataRepository(authenticatedHttpClient, tenantInformation), lazy: false),
            RepositoryProvider(create: (context) => OpenProductionDataRepository(authenticatedHttpClient: authenticatedHttpClient, tenantInformation: tenantInformation, errorRepository: errorRepository), lazy: false),
            RepositoryProvider(
              create: (context) => UserPreferencesRepository(
                tenant: (context.read<TenantSelectionCubit>().state as TenantSelectedState).tenant.name, 
                userId: context.read<AuthDataCubit>().state!.userEmail
              ), 
              lazy: false
            ),
          ], 
          child: Builder(
            builder: (context) {
              return _child;
            }
          ));
  
  }
}