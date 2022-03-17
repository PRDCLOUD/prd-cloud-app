import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/loss/production_loss_add.dart';


class ProductionLossMain extends StatelessWidget {
  const ProductionLossMain({Key? key}) : super(key: key);

  Future<void> lossAddDialog(BuildContext context, List<Loss> lossOptions, List<LineUnit> lineUnits, LossAddCallback lossAddCallback, int productionBasicId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: LossAdd(
            productionBasicId: productionBasicId,
            lossOptions: lossOptions, 
            lineUnits: lineUnits, 
            lossAddCallback: lossAddCallback
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
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              lossAddDialog(context, lossesOptions, lineUnits, context.read<ProductionLossCubit>().addLoss, productionDataId);
            },
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Perdas Cadastradas:", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.losses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _LossCard(state, index, context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _LossCard(ProductionLossState state, int index, BuildContext context) {
    return ListTile(
      title: Card(
        child: Container(
          padding: const EdgeInsets.all(13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.losses[index].name, style: Theme.of(context).textTheme.bodyMedium),
                    Text(state.losses[index].getFormatedLossValue(), style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_outline), 
                label: const Text("Excluir"),
                style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.error),
                onLongPress: () async => await context.read<ProductionLossCubit>().removeLoss(context.read<SelectedProductionDataCubit>().state!, state.losses[index].id),
                onPressed: () async => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Segure o botão para deletar")))
              )
            ],
          )
        )
      ),
    );
  }


}
