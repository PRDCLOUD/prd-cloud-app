import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'Production_opened_bloc_provider.dart';
import 'production_selected_summary.dart';

class ProductionOpenedItemLayoutPage extends StatelessWidget {
  const ProductionOpenedItemLayoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SelectedProductionDataCubit, int?>(
        builder: (BuildContext context, state) {
          var selectedProductionData = context.read<OpenProductionDataCubit>().state.loadedItems.cast<ProductionBasicData?>().firstWhere((element) => element?.id == state, orElse: () => null);
          if (selectedProductionData != null) {
            return Column(
              key: UniqueKey(),
              children: [
                ProductionSelectedSummary(productionData: selectedProductionData),
                Expanded(child: _Bottom(selectedProductionBasicData: selectedProductionData))
              ],
            );
          } else {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sem apontamentos selecionados", style: Theme.of(context).textTheme.bodyLarge,),
                  const SizedBox(height: 20),
                  const Text("Selecione os apontamentos que deseja editar na list de apontamentos"),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    child: const Text("Ir para lista de apontamentos"),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(50, 50)),
                    onPressed: () => context.read<MenuItemSelectedCubit>().selectPage(MenuItemSelected.productionDataList),
                  )
                ],
              ),
            );
          }
        })
      );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom({
    Key? key,
    required ProductionBasicData selectedProductionBasicData
  }) : _selectedProductionBasicData = selectedProductionBasicData, super(key: key);

  final ProductionBasicData _selectedProductionBasicData;

  @override
  Widget build(BuildContext context) {
    return ProductionOpenedBlocProvider(productionBasicDataId: _selectedProductionBasicData.id);
  }
}