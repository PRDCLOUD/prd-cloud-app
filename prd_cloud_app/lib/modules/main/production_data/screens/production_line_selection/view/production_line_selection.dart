import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/initial/bloc/production_line_and_groups/production_line_and_groups_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/selected_production_line_and_groups/selected_production_line_and_groups_cubit.dart';

class ProductionLineSelectionPage extends StatelessWidget {
  const ProductionLineSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductionLineSelectionList(
      allProductionLines: (context.read<ProductionLineAndGroupsCubit>().state as ProductionLineAndGroupLoaded).productionLineAndGroups,
      initalSelectionProductionLines: context.read<SelectedProductionLineAndGroupsCubit>().state.selectedProductionLinesAndGroups,
      confirmation: (selectedItems) => context.read<SelectedProductionLineAndGroupsCubit>().setNewSelectedItems(selectedItems),
      enableCancel: false,
      popAfterConfirm: false,
    );
  }
}

typedef ProductionLineSelectionConfirmation = void Function(List<ProductionLineAndGroup>);
class ProductionLineSelectionList extends StatefulWidget {
  const ProductionLineSelectionList({
    Key? key, 
    required this.allProductionLines, 
    required this.initalSelectionProductionLines,
    required this.confirmation,
    required this.enableCancel,
    required this.popAfterConfirm
  }) : super(key: key);

  final List<ProductionLineAndGroup> allProductionLines;
  final List<ProductionLineAndGroup> initalSelectionProductionLines;
  final ProductionLineSelectionConfirmation confirmation;
  final bool enableCancel;
  final bool popAfterConfirm;

  @override
  State<ProductionLineSelectionList> createState() => _ProductionLineSelectionListState();
}

class _ProductionLineSelectionListState extends State<ProductionLineSelectionList> {

  List<ProductionLineAndGroup> selectedProductionLines = List.empty();

  @override
  void initState() {
    setState(() {
      selectedProductionLines = widget.initalSelectionProductionLines;
    });
    super.initState();
  }

  selectItem(ProductionLineAndGroup item) {
    if (!selectedProductionLines.contains(item)) {
      setState(() {
        selectedProductionLines = selectedProductionLines.toList()..add(item);
      });
    }
  }

  removeItem(ProductionLineAndGroup item) {
    if (selectedProductionLines.contains(item)) {
      setState(() {
        selectedProductionLines = selectedProductionLines.toList()..remove(item);
      });
    }
  }

  isSelected(ProductionLineAndGroup item) => selectedProductionLines.contains(item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Selecione as Linhas de Produção')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.allProductionLines.length,
              itemBuilder: (BuildContext context, int index) {
                var selected = isSelected(widget.allProductionLines[index]);
                return Card(
                  child: ListTile(
                    leading: selected ? const Icon(Icons.check) : const Icon(Icons.circle_outlined),
                    title: Text(widget.allProductionLines[index].name),
                    onTap: selected ? 
                      () => removeItem(widget.allProductionLines[index]) :
                      () => selectItem(widget.allProductionLines[index])
                  )
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: const Text("Confirmar"),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(150, 40)),
                  onPressed: selectedProductionLines.isEmpty ? null : () {
                    widget.confirmation(selectedProductionLines);
                    if (widget.popAfterConfirm) {
                      Navigator.pop(context);
                    }
                  }
                ),
                if (widget.enableCancel)
                  ...[ ElevatedButton(
                      child: const Text("Cancelar"),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(150, 40), primary: Theme.of(context).colorScheme.error),
                      onPressed: () => Navigator.pop(context)
                    )
                  ]
                  
                else
                  ...[]
              ],
            ),
          )
        ],
      ),
    );
  }
}