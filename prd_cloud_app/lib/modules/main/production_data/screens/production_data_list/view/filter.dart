import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/production_list_filter_cubit/production_list_filter_cubit.dart';


class Filter extends StatelessWidget {
  const Filter({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductionListFilterCubit, ProductionDataFilter>(
      builder: (context, state) {
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
            ),
          ],
        );
      },
    );
  }

  bool isOpened (ProductionDataStatus currentStatus) => currentStatus == ProductionDataStatus.opened;
  bool isConcluded (ProductionDataStatus currentStatus) => currentStatus == ProductionDataStatus.concluded;
  bool isCanceled (ProductionDataStatus currentStatus) => currentStatus == ProductionDataStatus.canceled;
  Icon? avatar(bool showAvatar) => showAvatar ? const Icon(Icons.check) : null;
}