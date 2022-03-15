import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/initial/bloc/production_line_and_groups/production_line_and_groups_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/selected_production_line_and_groups/selected_production_line_and_groups_cubit.dart';

class ProductionLineSelectionPage extends StatelessWidget {
  const ProductionLineSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productionLineOptions = (context.read<ProductionLineAndGroupsCubit>().state as ProductionLineAndGroupLoaded).productionLineAndGroups;
    return Scaffold(
      body: BlocBuilder<SelectedProductionLineAndGroupsCubit, SelectedProductionLineAndGroupsState>(
          builder: (BuildContext context, state) {
            return ListView.builder(
              itemCount: productionLineOptions.length,
              itemBuilder: (BuildContext context, int index) {
                var selected = state.isSelected(productionLineOptions[index]);
                return Card(
                  child: ListTile(
                    leading: selected ? const Icon(Icons.check) : const Icon(Icons.circle_outlined),
                    title: Text(productionLineOptions[index].name),
                    onTap: selected ? 
                      () => context.read<SelectedProductionLineAndGroupsCubit>().remove(productionLineOptions[index]) :
                      () => context.read<SelectedProductionLineAndGroupsCubit>().select(productionLineOptions[index])
                  )
                );
              }
            );
          },
        ),
      );
  }
}