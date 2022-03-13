import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/widgets/widgets.dart';
import 'package:production_data_repository/production_data_repository.dart';

class ProductionVariableEdit extends StatelessWidget {
  const ProductionVariableEdit({Key? key, required this.productionVariable}) : super(key: key);

  final ProductionVariable productionVariable;

  @override
  Widget build(BuildContext context) {
    if (productionVariable.typeVariableDefinition.toLowerCase() == 'numeric') {
      return BlocProvider(
          create: (context) => FieldVariableNumericCubit(
              productionBasicDataId: productionVariable.productionBasicDataId,
              variableDataId: productionVariable.id,
              label: productionVariable.implementationLabel,
              decimals: productionVariable.decimalPlaces ?? 0,
              initialValue: productionVariable.value,
              openProductionDataRepository: context.read<OpenProductionDataRepository>()),
          child: const _NumericVariable(),
      );
    } else {
      return BlocProvider(
          create: (context) => FieldVariableTextCubit(
              productionBasicDataId: productionVariable.productionBasicDataId,
              variableDataId: productionVariable.id,
              label: productionVariable.implementationLabel,
              initialValue: productionVariable.text,
              openProductionDataRepository: context.read<OpenProductionDataRepository>()),
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

