import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/initial/bloc/selected_production_line_and_groups/selected_production_line_and_groups_cubit.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/create_input_data/create_input_data.dart';
import 'Production_opened_bloc_provider.dart';
import 'production_selected_summary.dart';

class ProductionOpenedItemLayoutPage extends StatelessWidget {
  const ProductionOpenedItemLayoutPage({Key? key}) : super(key: key);

  showSelectionProductionLines(BuildContext context) {
    var selectedProductionLines = context.read<SelectedProductionLineAndGroupsCubit>().state.selectedProductionLinesAndGroups;
    var confirmation = context.read<OpenProductionDataCubit>().openNewProductionData;
    var refresh = context.read<ProductionListFilterCubit>().markForRefresh;

    Future<void> confirmationAndSetRefresh(List<ProductionLineAndGroup> productionLineAndGroups) async {
      await confirmation(productionLineAndGroups);
      refresh();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CreateInputProductionLineSelectionList(
          allProductionLines: selectedProductionLines,
          initalSelectionProductionLines: const [],
          confirmation: confirmationAndSetRefresh,
          enableCancel: true,
          popAfterConfirm: true,
        );
      }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OpenProductionDataCubit, OpenProductionDataState>(
        listener: (context, state) {
          if (state.loadingItem) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }
        },
        child: BlocBuilder<SelectedProductionDataCubit, int?>(
            builder: (BuildContext context, state) {
              var selectedProductionData = context
                  .read<OpenProductionDataCubit>()
                  .state
                  .loadedItems
                  .cast<ProductionDataGroup?>()
                  .firstWhere((element) => state != null && element != null && element.hasProductionData(state), orElse: () => null);
              if (selectedProductionData != null) {
                return Column(
                  key: UniqueKey(),
                  children: [
                    ProductionSelectedSummary(productionGroup: selectedProductionData),
                    Expanded(
                        child: _Bottom(
                            selectedProductionDataGroup: selectedProductionData))
                  ],
                );
              } else {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sem apontamentos selecionados",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      const Text("Selecione os apontamentos que deseja editar na lista de apontamentos"),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        child: const Text("Ir para lista de apontamentos"),
                        style:
                            ElevatedButton.styleFrom(minimumSize: const Size(50, 50)),
                        onPressed: () => context
                            .read<MenuItemSelectedCubit>()
                            .selectPage(MenuItemSelected.productionDataList),
                      ),
                      const SizedBox(height: 80),
                      const Text("Ou crie um novo apontamento"),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        child: const Text("Criar novo apontamento"),
                        style:
                            ElevatedButton.styleFrom(minimumSize: const Size(50, 50)),
                        onPressed: () => showSelectionProductionLines(context),
                      ),
                    ],
                  ),
                );
              }
            }
          ),
      )
    );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom({Key? key, required this.selectedProductionDataGroup}) : super(key: key);

  final ProductionDataGroup selectedProductionDataGroup;

  @override
  Widget build(BuildContext context) {
    return ProductionOpenedBlocProvider(productionBasicDataId: selectedProductionDataGroup.getId());
  }
}
