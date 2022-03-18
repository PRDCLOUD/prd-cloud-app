import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/initial/bloc/selected_production_line_and_groups/selected_production_line_and_groups_cubit.dart';

import 'bloc_setup/bloc_setup.dart';
import 'menu/drawer_menu.dart';
import 'screens/production_line_selection/production_line_selection.dart';

class ProductionDataModule extends StatefulWidget {
  const ProductionDataModule({Key? key}) : super(key: key);

  @override
  State<ProductionDataModule> createState() => _ProductionDataModuleState();
}

class _ProductionDataModuleState extends State<ProductionDataModule> {
  bool productionLineSelected = false;

  @override
  void initState() {
    if (context
        .read<SelectedProductionLineAndGroupsCubit>()
        .state
        .selectedProductionLinesAndGroups
        .isNotEmpty) {
      setState(() {
        productionLineSelected = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSetup(
        child: BlocListener<SelectedProductionLineAndGroupsCubit, SelectedProductionLineAndGroupsState>(
      listener: (context, state) {
        if (state.selectedProductionLinesAndGroups.isEmpty) {
          setState(() {
            productionLineSelected = false;
          });
        } else {
          setState(() {
            productionLineSelected = true;
          });
        }
      },
      child: menuOrProductionLineSelectionWidget(),
    ));
  }

  StatelessWidget menuOrProductionLineSelectionWidget() =>
      productionLineSelected
          ? const DrawerMenu()
          : const ProductionLineSelectionPage();
}
