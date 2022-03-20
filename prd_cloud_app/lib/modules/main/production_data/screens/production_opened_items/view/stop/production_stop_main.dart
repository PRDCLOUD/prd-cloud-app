import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/theme.dart';
import 'production_stop_add.dart';


class ProductionStopMain extends StatelessWidget {
  const ProductionStopMain({Key? key}) : super(key: key);

  void stopAddDialog(BuildContext context, List<Stop> stopOptions, List<LineUnit> lineUnits, StopAddCallback stopAddCallback, int productionBasicId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => 
        StopAdd(
            productionBasicId: productionBasicId,
            stopOptions: stopOptions, 
            lineUnits: lineUnits, 
            stopAddCallback: stopAddCallback
          )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var productionDataId = context.read<SelectedProductionDataCubit>().state as int;

    var group = context
        .read<OpenProductionDataCubit>()
        .state
        .loadedItems
        .firstWhere((e) => e.hasProductionData(productionDataId));
    
    var stopOptions = group.getProductionStopOptions();
    var lineUnits = group.getLineUnits().toList();

    return BlocConsumer<ProductionStopCubit, ProductionStopState>(
      listener: (context, state) => { 
        if (state.status == ProductionStopStatus.adding || state.status == ProductionStopStatus.deleting) {
          context.loaderOverlay.show()
        } else {
          context.loaderOverlay.hide()
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              stopAddDialog(context, stopOptions, lineUnits, context.read<ProductionStopCubit>().addStop, productionDataId);
            },
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Paradas Cadastradas:", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
              Expanded(
                child:ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.stops.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _stopCard(state, index, context, lineUnits);
                  },
                ),
              )
            ]
          )
        );
      },
    );
  }

Widget _stopCard(ProductionStopState state, int index, BuildContext context, List<LineUnit> lineUnits) {

  Future showDeleteAlertDialog() async {
      // set up the button
      Widget okButton = TextButton(
        style: TextButton.styleFrom(primary: Theme.of(context).colorScheme.error),
        child: const Text("Confirmar"),
        onPressed: () { 
          Navigator.of(context).pop();
          context.read<ProductionStopCubit>().removeStop(context.read<SelectedProductionDataCubit>().state!, state.stops[index].id);
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
        content: const Text("ATENÇÃO: Você tem certeza que deseja excluir a parada?"),
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

    return ListTile(
      title: Card(
        shape: AppTheme.cardShape,
        child: Container(
          padding: const EdgeInsets.all(13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.build_outlined, size: 12), 
                        const SizedBox(width: 5), 
                        Text(state.stops[index].name, style: Theme.of(context).textTheme.bodyMedium) 
                      ]
                    ),
                    Row(
                      children: [
                        const Icon(Icons.precision_manufacturing_outlined, size: 12), 
                        const SizedBox(width: 5), 
                        Text(lineUnits.firstWhere((lineUnit) => lineUnit.id == state.stops[index].lineUnitId).name, style: Theme.of(context).textTheme.bodyMedium)
                      ]
                    ),
                    Row(
                      children: [
                        const Icon(Icons.av_timer_outlined, size: 12), 
                        const SizedBox(width: 5), 
                        Text(state.stops[index].getFormatedStopValue(), style: Theme.of(context).textTheme.bodySmall),
                      ]
                    )
                  ],
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_outline), 
                label: const Text("Excluir"),
                style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.error),
                onLongPress: () => showDeleteAlertDialog(),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Segure o botão para deletar")))
              )
            ],
          )
        )
      ),
    );
  }
  
  

}
