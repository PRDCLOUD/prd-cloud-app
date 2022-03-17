import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/open_production_data_cubit/open_production_data_cubit.dart';
import 'package:prd_cloud_app/modules/main/bloc/production_list_filter_cubit/production_list_filter_cubit.dart';
import 'package:prd_cloud_app/modules/main/bloc/selected_production_data_cubit/selected_production_data_cubit.dart';

import 'production_opened_item_selection_list.dart';

class ProductionSelectedSummary extends StatelessWidget {
  const ProductionSelectedSummary({Key? key, required ProductionBasicData productionData}) : _productionData = productionData, super(key: key);

  final ProductionBasicData _productionData;

  @override
  Widget build(BuildContext context) {

    var productionLine = _productionData.lineUnits.firstWhere((e) => e.type == 'ProductionLine');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              _ProductionLineSelectionButton(productionData: _productionData, productionLine: productionLine),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  child: const Icon(Icons.check, size: 35,),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(56, 118, 29, 1),
                    fixedSize: const Size(60, 60)
                  ),
                  onPressed: () {
                    context.read<OpenProductionDataCubit>().concludeProductionData(_productionData.id);
                  }),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  child: const Icon(Icons.close, size: 35,),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.secondary,
                    fixedSize: const Size(60, 60)
                  ),
                  onPressed: () {
                    context.read<OpenProductionDataCubit>().closeProductionData(_productionData.id);
                  }),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: ElevatedButton(
                  child: const Icon(Icons.delete_outline, size: 35,),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.error,
                    fixedSize: const Size(60, 60)
                  ),
                  onPressed: () {
                    context.read<OpenProductionDataCubit>().cancelProductionData(_productionData.id);
                    context.read<ProductionListFilterCubit>().markForRefresh();
                  },
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}

class _ProductionLineSelectionButton extends StatelessWidget {
  const _ProductionLineSelectionButton({
    Key? key,
    required ProductionBasicData productionData,
    required this.productionLine,
  }) : _productionData = productionData, super(key: key);

  final ProductionBasicData _productionData;
  final ProductionLineUnit productionLine;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
        onPressed: () => Navigator.of(context).push(ProductionOpenedItemSelectionListPage.route(context.read<OpenProductionDataCubit>(), context.read<SelectedProductionDataCubit>())),
        child: Row(
          children: [ 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Linha: " + productionLine.name, style: Theme.of(context).textTheme.headline6),
                  Text("ID " + _productionData.id.toString(), style: Theme.of(context).textTheme.bodyLarge,)
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down_sharp)
          ],
        ),
      )
    );
  }
}