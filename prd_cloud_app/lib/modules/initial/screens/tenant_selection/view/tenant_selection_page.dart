import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/initial/bloc/tenant_options/tenant_options_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/tenant_selection/tenant_selection_cubit.dart';

class TenantSelectionPage extends StatelessWidget {
  const TenantSelectionPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const TenantSelectionPage());
  }

  @override
  Widget build(BuildContext context) {

    final tenantOptions = context.select((TenantOptionsCubit bloc) => bloc.state).tenants.toList();

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Selectione a Planta')),
      body: ListView.builder(
        itemCount: tenantOptions.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            style: ListTileStyle.list,
            title: Card(
              child: Center(child: 
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(tenantOptions[index].name,
                    style: Theme.of(context).textTheme.titleLarge
                  ),
                )
              )
            ),
            onTap: () => context.read<TenantSelectionCubit>().selectTenant(tenantOptions[index])
          );
        }
      )
    );
  }
}