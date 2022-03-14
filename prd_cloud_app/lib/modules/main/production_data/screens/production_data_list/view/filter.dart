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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                child: Chip(
                  label: const Text("Em Aberto"),
                  backgroundColor: state.status == ProductionDataStatus.opened ? Colors.green : Colors.grey
                ),
                onTap: () => context.read<ProductionListFilterCubit>().updateStatus(ProductionDataStatus.opened),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                child: Chip(
                  label: const Text("Concluído"),
                  backgroundColor: state.status == ProductionDataStatus.concluded ? Colors.green : Colors.grey
                ),
                onTap: () => context.read<ProductionListFilterCubit>().updateStatus(ProductionDataStatus.concluded),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                child: Chip(
                  label: const Text("Cancelado"),
                  backgroundColor: state.status == ProductionDataStatus.canceled ? Colors.green : Colors.grey
                ),
                onTap: () => context.read<ProductionListFilterCubit>().updateStatus(ProductionDataStatus.canceled),
              ),
            ),
          ],
        );
      },
    );
  }
}