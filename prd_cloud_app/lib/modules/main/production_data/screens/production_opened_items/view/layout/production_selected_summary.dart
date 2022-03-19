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

    Future showDeleteAlertDialog() async {
      // set up the button
      Widget okButton = TextButton(
        style: TextButton.styleFrom(primary: Theme.of(context).colorScheme.error),
        child: const Text("Confirmar"),
        onPressed: () { 
          Navigator.of(context).pop();
          context.read<OpenProductionDataCubit>().cancelProductionData(_productionData.id);
          context.read<ProductionListFilterCubit>().markForRefresh();
        },
      );

      Widget cancelButton = TextButton(
        child: const Text("Cancelar"),
        onPressed: () { 
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Confirmar exclusão"),
        content: const Text("ATENÇÃO: Você tem certeza que deseja excluir o apontamento?"),
        actions: [
          okButton,
          cancelButton
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    var productionLine = _productionData.lineUnits.firstWhere((e) => e.type == 'ProductionLine');
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            offset: const Offset(0, 2),
            blurRadius: 3.0,
            spreadRadius: 0
          )
        ]      
      ),
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
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Segure o botão para concluir o apontamento')),
                    );
                },
                onLongPress: () {
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
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Segure o botão para fechar a edição do apontamento')),
                    );
                },
                onLongPress: () {
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
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Segure o botão para excluir o apontamento')),
                    );
                },
                onLongPress: () {
                  showDeleteAlertDialog();
                },
              ),
            ),
          ]
        ),
      ),
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
      child: ElevatedButton(
        style: TextButton.styleFrom(
          primary: Theme.of(context).colorScheme.primary,
          minimumSize: const Size(60, 60)
        ),
        onPressed: () => Navigator.of(context).push(ProductionOpenedItemSelectionListPage.route(context.read<OpenProductionDataCubit>(), context.read<SelectedProductionDataCubit>())),
        child: Row(
          children: [ 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Linha: " + productionLine.name, style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
                  Text("ID " + _productionData.id.toString(), style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),)
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down_sharp, size: 40, color: Colors.white,)
          ],
        ),
      )
    );
  }
}