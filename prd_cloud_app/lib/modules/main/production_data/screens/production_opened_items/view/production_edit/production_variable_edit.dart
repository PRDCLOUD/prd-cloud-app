import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/widgets/widgets.dart';
import 'package:production_data_repository/production_data_repository.dart';

class ProductionVariableEdit extends StatelessWidget {
  const ProductionVariableEdit(
      {Key? key,
      required int productionBasicDataId,
      required int productionVariableId})
      : _productionBasicDataId = productionBasicDataId,
        _productionVariableId = productionVariableId,
        super(key: key);

  final int _productionBasicDataId;
  final int _productionVariableId;

  @override
  Widget build(BuildContext context) {
    var productionData = context
        .read<OpenProductionDataCubit>()
        .state
        .loadedItems
        .firstWhere((element) => element.id == _productionBasicDataId);
    var variable = productionData.lineUnits
        .map((e) => e.lineUnit)
        .expand((e) => e.productionVariables)
        .firstWhere((e) => e.id == _productionVariableId);
    var openProductionDataRepository =
        context.read<OpenProductionDataRepository>();

    if (variable.typeVariableDefinition.toLowerCase() == 'numeric') {
      return BlocProvider(
          create: (context) => FieldVariableNumericCubit(
              productionBasicDataId: _productionBasicDataId,
              variableDataId: _productionVariableId,
              label: variable.implementationLabel,
              decimals: variable.decimalPlaces ?? 0,
              initialValue: variable.value,
              openProductionDataRepository: openProductionDataRepository),
          child: const _NumericVariable(),
      );
    } else {
      return BlocProvider(
          create: (context) => FieldVariableTextCubit(
              productionBasicDataId: _productionBasicDataId,
              variableDataId: _productionVariableId,
              label: variable.implementationLabel,
              initialValue: variable.text,
              openProductionDataRepository: openProductionDataRepository),
          child: Text("AAA"),
      );
    }
  }
}

class _NumericVariable extends StatelessWidget {
  const _NumericVariable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldVariableNumericCubit, FieldVariableNumericState>(
      builder: (context, state) {
        return NumberInput(
          label: state.label,
          allowDecimal: state.decimals > 0,
          value: state.fieldValue?.toString().replaceAll(",", "."), 
          onChanged: (newValue) => context.read<FieldVariableNumericCubit>().updateField(newValue == null || newValue == "" ? null : double.parse(newValue)),
        )          ;
      },
    );
  }
}

