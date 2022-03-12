import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'production_summary.dart';

class ProductionOpenedItemPage extends StatelessWidget {
  const ProductionOpenedItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SelectedProductionDataCubit, SelectedProductionDataState>(
          builder: (BuildContext context, state) {
            return Column(
              children: [
                SelectedProductionDataSummary(state: state)

              ],
            );
          })
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
        child: Center(child: Text("Nenhum item selecionado")),
        onTap: () => {},
      );
    } else {
      return ProductionSummary(productionData: state.selectedItem as ProductionBasicData);
    }
  }
}