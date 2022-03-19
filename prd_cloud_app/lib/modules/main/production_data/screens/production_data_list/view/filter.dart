import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/initial/bloc/production_line_and_groups/production_line_and_groups_cubit.dart';
import 'package:prd_cloud_app/modules/initial/bloc/selected_production_line_and_groups/selected_production_line_and_groups_cubit.dart';
import 'package:prd_cloud_app/modules/main/bloc/production_list_filter_cubit/production_list_filter_cubit.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_line_selection/production_line_selection.dart';


class Filter extends StatelessWidget {
  const Filter({ Key? key }) : super(key: key);

  showSelectionProductionLines(BuildContext context) {
    var allProductionLines = (context.read<ProductionLineAndGroupsCubit>().state as ProductionLineAndGroupLoaded).productionLineAndGroups;
    var initalSelectionProductionLines = context.read<SelectedProductionLineAndGroupsCubit>().state.selectedProductionLinesAndGroups;
    var confirmation = context.read<SelectedProductionLineAndGroupsCubit>().setNewSelectedItems;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ProductionLineSelectionList(
          allProductionLines: allProductionLines,
          initalSelectionProductionLines: initalSelectionProductionLines,
          confirmation: confirmation,
          enableCancel: true,
          popAfterConfirm: true,
        );
      }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductionListFilterCubit, ProductionDataFilter>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: Row(
                children: const [
                  Text("Linhas de Produção"),
                  Icon(Icons.filter_alt),
                ]
              ),
              onPressed: () {
                showSelectionProductionLines(context);
              },
            ),
            choiceChips(state, context),
          ],
        );
      },
    );
  }

  Widget choiceChips(ProductionDataFilter state, BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ChoiceChip(
            label: const Text("Em Aberto"),
            avatar: avatar(isOpened(state.status)),
            selected: isOpened(state.status),
            onSelected: (selected) => context.read<ProductionListFilterCubit>().updateStatus(ProductionDataStatus.opened)
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ChoiceChip(
            label: const Text("Concluído"),
            avatar: avatar(isConcluded(state.status)),
            selected: isConcluded(state.status),
            onSelected: (selected) => context.read<ProductionListFilterCubit>().updateStatus(ProductionDataStatus.concluded),
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ChoiceChip(
            label: const Text("Cancelado"),
            avatar: avatar(isCanceled(state.status)),
            selected: isCanceled(state.status),
            onSelected: (selected) => context.read<ProductionListFilterCubit>().updateStatus(ProductionDataStatus.canceled),
          )
        )
      ]
    );
  }

  bool isOpened (ProductionDataStatus currentStatus) => currentStatus == ProductionDataStatus.opened;
  bool isConcluded (ProductionDataStatus currentStatus) => currentStatus == ProductionDataStatus.concluded;
  bool isCanceled (ProductionDataStatus currentStatus) => currentStatus == ProductionDataStatus.canceled;
  Icon? avatar(bool showAvatar) => showAvatar ? const Icon(Icons.check) : null;
}