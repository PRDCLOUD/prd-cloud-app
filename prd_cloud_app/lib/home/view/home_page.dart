import 'package:apontamentos_repository/apontamento_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/business_layer/apontamentos/bloc/apontamentos_bloc.dart';
import 'package:prd_cloud_app/business_layer/business_layer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO stream apontamentos_bloc
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocProvider(
          create: (context) => ApontamentosBloc(apontamentosRepository: context.read<ApontamentosRepository>())..add(ApontamentosRefreshEvent(take: 100)),
          child: BlocBuilder<ApontamentosBloc, ApontamentosState>(
            builder: (BuildContext context, state) {
              switch (state.status) {
                case ApontamentosLoadState.loading:
                  return const Text("loading");
                case ApontamentosLoadState.loaded:
                  return const Text("loaded");
                case ApontamentosLoadState.notLoaded:
                  return const Text("Not Loaded");
              }
            },
          ),
        )
      );
      
    //   Center(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: <Widget>[
    //         Builder(
    //           builder: (context) {
    //             final tenantState = context.select((TenantOptionsCubit bloc) => bloc.state);
    //             return Text(tenantState.tenants.join("-"));
    //           },
    //         ),
    //         ElevatedButton(
    //           child: const Text('Logout'),
    //           onPressed: () {
    //             context
    //                 .read<AuthenticationBloc>()
    //                 .add(AuthenticationLogoutRequested());
    //           },
    //         ),
    //         ElevatedButton(
    //           child: const Text('Refresh'),
    //           onPressed: () {
    //             context
    //                 .read<AuthenticationBloc>()
    //                 .add(AuthenticationRefreshRequested());
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}