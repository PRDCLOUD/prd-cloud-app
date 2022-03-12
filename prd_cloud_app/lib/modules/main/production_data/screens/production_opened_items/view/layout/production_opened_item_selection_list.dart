import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';

import 'production_summary.dart';

class ProductionOpenedItemSelectionListPage extends StatelessWidget {
  const ProductionOpenedItemSelectionListPage({Key? key, required OpenProductionDataCubit openProductionDataCubit, required SelectedProductionDataCubit selectedProductionDataCubit}) 
    : _openProductionDataCubit = openProductionDataCubit, _selectedProductionDataCubit = selectedProductionDataCubit, super(key: key);

  final OpenProductionDataCubit _openProductionDataCubit;
  final SelectedProductionDataCubit _selectedProductionDataCubit;

  static MaterialPageRoute<void> route(OpenProductionDataCubit openProductionDataCubit, SelectedProductionDataCubit selectedProductionDataCubit) => MaterialPageRoute(
    builder: (_) => ProductionOpenedItemSelectionListPage(openProductionDataCubit: openProductionDataCubit, selectedProductionDataCubit: selectedProductionDataCubit),
  );

  selectProductionData(BuildContext context, ProductionBasicData productionBasicData) {
    _selectedProductionDataCubit.selectProductionData(productionBasicData.id);
    Navigator.pop(context);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: _openProductionDataCubit.state.loadedItems.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => { selectProductionData(context, _openProductionDataCubit.state.loadedItems[index]) },
              child: ProductionSummary(productionData: _openProductionDataCubit.state.loadedItems[index],)
            );
          }
        )
      );
  }


}