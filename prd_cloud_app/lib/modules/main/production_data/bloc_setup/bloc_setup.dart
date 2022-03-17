import 'package:error_repository/error_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/initial/bloc/selected_production_line_and_groups/selected_production_line_and_groups_cubit.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:production_data_repository/production_data_repository.dart';

class BlocSetup extends StatelessWidget {
  const BlocSetup({Key? key, required Widget child})
      : _child = child,
        super(key: key);

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      child: _BlocListeners(child: _child),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  const _BlocProvider({Key? key, required Widget child})
      : _child = child,
        super(key: key);

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => MenuItemSelectedCubit(), lazy: false),
      BlocProvider(
          create: (context) => ProductionDataCubit(
              errorRepository: context.read<ErrorRepository>(),
              apontamentosRepository:
                  context.read<ProductionDataRepository>())),
      BlocProvider(
          create: (context) => OpenProductionDataCubit(
              errorRepository: context.read<ErrorRepository>(),
              openProductionDataRepository:
                  context.read<OpenProductionDataRepository>()),
          lazy: false),
      BlocProvider(
          create: (context) => SelectedProductionDataCubit(), lazy: false),
      BlocProvider(
          create: (context) => ProductionListFilterCubit(ProductionDataFilter(
              prdLines: context
                  .read<SelectedProductionLineAndGroupsCubit>()
                  .state
                  .selectedProductionLinesAndGroups
                  .map((e) => e.id)
                  .toList(),
              status: ProductionDataStatus.opened,
              take: 200)),
          lazy: false),
      BlocProvider(
          create: (context) =>
              ErrorCubit(errorRepository: context.read<ErrorRepository>()),
          lazy: false)
    ], child: _child);
  }
}

class _BlocListeners extends StatelessWidget {
  const _BlocListeners({Key? key, required Widget child})
      : _child = child,
        super(key: key);

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectedProductionLineAndGroupsCubit,
        SelectedProductionLineAndGroupsState>(
      listener: (context, state) {
        context
            .read<ProductionListFilterCubit>()
            .updateProductionLines(state.selectedProductionLinesAndGroups);
      },
      child: BlocListener<OpenProductionDataCubit, OpenProductionDataState>(
        listener: (context, state) {
          var selectedProductionData = context.read<SelectedProductionDataCubit>().state;
          var openProductionData = state.loadedItems;
          if (openProductionData.isEmpty) {
            context.read<SelectedProductionDataCubit>().unselectProductionData();
          }
          else if (!openProductionData.any((element) => element.id == selectedProductionData)) {
            context.read<SelectedProductionDataCubit>().selectProductionData(openProductionData.first.id);
          }
        },
        child: _child,
      ),
    );
  }
}
