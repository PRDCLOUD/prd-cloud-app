import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';
import 'package:production_data_repository/production_data_repository.dart';

class ProductionVariableEdit extends StatelessWidget {
  const ProductionVariableEdit({Key? key, required this.productionVariable})
      : super(key: key);

  final ProductionVariable productionVariable;

  @override
  Widget build(BuildContext context) {
    if (productionVariable.typeVariableDefinition.toLowerCase() == 'numeric') {
      return BlocProvider(
        create: (context) => FieldVariableNumericCubit(
            productionBasicDataId: productionVariable.productionBasicDataId,
            variableDataId: productionVariable.id,
            label: productionVariable.implementationLabel,
            enabled: !productionVariable.isReadOnly,
            decimals: productionVariable.decimalPlaces ?? 0,
            initialValue: productionVariable.value,
            openProductionDataRepository:
                context.read<OpenProductionDataRepository>()),
        child: const _NumericVariable(),
      );
    } else {
      return BlocProvider(
        create: (context) => FieldVariableTextCubit(
            productionBasicDataId: productionVariable.productionBasicDataId,
            variableDataId: productionVariable.id,
            label: productionVariable.implementationLabel,
            enabled: !productionVariable.isReadOnly,
            options: productionVariable.textOptionsList,
            initialValue: productionVariable.text,
            openProductionDataRepository:
                context.read<OpenProductionDataRepository>()),
        child: const _TextVariable(),
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
        if (state.enabled) {
          return NumberInput(
            key: UniqueKey(),
            label: state.label,
            allowDecimal: state.decimals > 0,
            value: state.fieldValue,
            onChanged: (newValue) => context.read<FieldVariableNumericCubit>().updateField(newValue),
          );
        } else {
          return TextFormField(
            key: UniqueKey(),
            initialValue: state.fieldValue == null ? null : NumberFormat("##0.##", "en_US").format(state.fieldValue),
            enabled: false,
            decoration: InputDecoration(
              label: Text(state.label),
            ),
          );
        }
      },
    );
  }
}

class _TextVariable extends StatelessWidget {
  const _TextVariable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldVariableTextCubit, FieldVariableTextState>(
      key: UniqueKey(),
      builder: (context, state) {
        if (state.options == null || state.options!.isEmpty || !state.enabled) {
          return _TextField(key: UniqueKey(), label: state.label);
        } else {
          return _DropdownField(key: UniqueKey(), label: state.label);
        }
      },
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({Key? key, required String label}) : _label = label, super(key: key);

  final String _label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      initialValue: context.read<FieldVariableTextCubit>().state.fieldValue,
      enabled: context.read<FieldVariableTextCubit>().state.enabled,
      onChanged: context.read<FieldVariableTextCubit>().updateField,
      decoration: InputDecoration(
        label: Text(_label),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({Key? key, required String label}) : _label = label, super(key: key);

  final String _label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldVariableTextCubit, FieldVariableTextState>(
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          key: UniqueKey(),
          decoration: InputDecoration(
            label: Text(_label),
          ),
          value: state.fieldValue,
          onChanged: context.read<FieldVariableTextCubit>().updateField,
          items: state.options!.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }
}
