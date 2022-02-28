import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/business_layer/business_layer.dart';
import 'package:prd_cloud_app/business_layer/tenant_options/cubit/tenant_options_cubit.dart';

class HomePage extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Builder(
              builder: (context) {
                final tenantState = context.select((TenantOptionsCubit bloc) => bloc.state);
                return Text(tenantState.tenants.join("-"));
              },
            ),
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
              },
            ),
            ElevatedButton(
              child: const Text('Refresh'),
              onPressed: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationRefreshRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
}