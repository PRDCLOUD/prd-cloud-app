import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/business_layer/business_layer.dart';
import 'package:prd_cloud_app/business_layer/tenant_options/cubit/tenant_options_cubit.dart';

class TenantSelectionPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TenantSelectionPage());
  }

  @override
  Widget build(BuildContext context) {

    final tenantOptions = context.select((TenantOptionsCubit bloc) => bloc.state).tenants.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Tenant')),
      body: ListView.builder(
        itemCount: tenantOptions.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Container(
              height: 50,
              child: Center(child: Text(tenantOptions[index].name)),
            ),
            onTap: () => context.read<TenantSelectionCubit>().selectTenant(tenantOptions[index])
          );
        }
      )
    );
  }
}