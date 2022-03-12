import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'Production_opened_bloc_provider.dart';
import 'production_opened_item_selection_list.dart';
import 'production_summary.dart';

class ProductionOpenedItemLayoutPage extends StatelessWidget {
  const ProductionOpenedItemLayoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SelectedProductionDataCubit, SelectedProductionDataState>(
          builder: (BuildContext context, state) {
            return Column(
              children: [
                GestureDetector(
                  child: SelectedProductionDataSummary(state: state),
                  onTap: () => Navigator.of(context).push(ProductionOpenedItemSelectionListPage.route(context.read<OpenProductionDataCubit>(), context.read<SelectedProductionDataCubit>()))
                ),
                Expanded(child: 
                  _Bottom(selectedProductionBasicData: state.selectedItem)
                )
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
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: ProductionOpenedBlocProvider(productionBasicDataId: _selectedProductionBasicData?.id as int)
    );
  }
}

class SelectedProductionDataSummary extends StatelessWidget {
  const SelectedProductionDataSummary({
    Key? key,
    required this.state,
  }) : super(key: key);

  final SelectedProductionDataState state;

  @override
  Widget build(BuildContext context) {
    if (state.selectedItem == null) {
      return GestureDetector(
        child: const Center(child: Text("Nenhum item disponível")),
        onTap: () => {},
      );
    } else {
      return ProductionSummary(productionData: state.selectedItem as ProductionBasicData);
    }
  }
}