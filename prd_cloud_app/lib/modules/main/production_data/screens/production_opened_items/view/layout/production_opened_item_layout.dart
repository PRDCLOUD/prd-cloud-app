import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'Production_opened_bloc_provider.dart';
import 'production_selected_summary.dart';
import 'production_summary.dart';

class ProductionOpenedItemLayoutPage extends StatelessWidget {
  const ProductionOpenedItemLayoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SelectedProductionDataCubit, int?>(
          builder: (BuildContext context, state) {
            var selectedProductionData = context.read<OpenProductionDataCubit>().state.loadedItems.cast<ProductionBasicData?>().firstWhere((element) => element?.id == state, orElse: () => null);
            return Column(
              children: [
                ProductionSelectedSummary(productionData: selectedProductionData!),
                Expanded(child: _Bottom(selectedProductionBasicData: selectedProductionData))
              ],
            );
          })
        );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom({
    Key? key,
    required ProductionBasicData? selectedProductionBasicData
  }) : _selectedProductionBasicData = selectedProductionBasicData, super(key: key);

  final ProductionBasicData? _selectedProductionBasicData;

  @override
  Widget build(BuildContext context) {
    if (_selectedProductionBasicData == null) {
      return const Center(child: Text("No Data"));
    }
    return ProductionOpenedBlocProvider(productionBasicDataId: _selectedProductionBasicData?.id as int);
  }
}

class SelectedProductionDataSummary extends StatelessWidget {
  const SelectedProductionDataSummary({Key? key, required this.productionData}) : super(key: key);

  final ProductionBasicData? productionData;

  @override
  Widget build(BuildContext context) {
    if (productionData == null) {
      return GestureDetector(
        child: const Center(child: Text("Nenhum item disponível")),
        onTap: () => {},
      );
    } else {
      return ProductionSummary(productionData: productionData!);
    }
  }
}