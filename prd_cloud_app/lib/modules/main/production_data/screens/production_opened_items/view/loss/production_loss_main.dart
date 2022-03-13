import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/loss/production_loss_add.dart';


class ProductionLossMain extends StatelessWidget {
  const ProductionLossMain({Key? key}) : super(key: key);

  Future<void> productSelection(BuildContext context, List<Loss> lossOptions, List<LineUnit> lineUnits, LossAdder lossAdder, int productionBasicId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: LossAdd(
            productionBasicId: productionBasicId,
            lossOptions: lossOptions, 
            lineUnits: lineUnits, 
            lossAdder: lossAdder
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
    
    var lossesOptions = productionData.lossesOptions;
    var lineUnits = productionData.lineUnits.map((e) => e.lineUnit).toList();

    return BlocConsumer<ProductionLossCubit, ProductionLossState>(
      listener: (context, state) => { 
        if (state.status == ProductionLossStatus.adding || state.status == ProductionLossStatus.deleting) {
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
            productSelection(context, lossesOptions, lineUnits, context.read<ProductionLossCubit>().addLoss, productionDataId);
          },
        ),
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: state.losses.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(state.losses[index].name),
              );
            },
          ),
        );
      },
    );
  }

  
  

}
