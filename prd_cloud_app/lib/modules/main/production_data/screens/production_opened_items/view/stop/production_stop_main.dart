import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'production_stop_add.dart';


class ProductionStopMain extends StatelessWidget {
  const ProductionStopMain({Key? key}) : super(key: key);

  Future<void> stopAddDialog(BuildContext context, List<Stop> stopOptions, List<LineUnit> lineUnits, StopAddCallback stopAddCallback, int productionBasicId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: StopAdd(
            productionBasicId: productionBasicId,
            stopOptions: stopOptions, 
            lineUnits: lineUnits, 
            stopAddCallback: stopAddCallback
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var productionDataId = context.read<SelectedProductionDataCubit>().state as int;

    var productionData = context
        .read<OpenProductionDataCubit>()
        .state
        .loadedItems
        .firstWhere((element) => element.id == productionDataId);
    
    var stopOptions = productionData.stopOptions;
    var lineUnits = productionData.lineUnits.map((e) => e.lineUnit).toList();

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
          child: const Icon(Icons.add),

          backgroundColor: Colors.green,
          onPressed: () {
            stopAddDialog(context, stopOptions, lineUnits, context.read<ProductionStopCubit>().addStop, productionDataId);
          },
        ),
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: state.stops.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(state.stops[index].name),
                onLongPress: () async => await context.read<ProductionStopCubit>().removeStop(context.read<SelectedProductionDataCubit>().state!, state.stops[index].id),
              );
            },
          ),
        );
      },
    );
  }

  
  

}
