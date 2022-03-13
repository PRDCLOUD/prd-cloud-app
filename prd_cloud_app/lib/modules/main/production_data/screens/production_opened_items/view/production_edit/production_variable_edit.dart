import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/widgets/widgets.dart';
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
            enabled: productionVariable.isReadOnly,
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
            enabled: productionVariable.isReadOnly,
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
        return NumberInput(
          label: state.label,
          allowDecimal: state.decimals > 0,
          value: state.fieldValue,
          onChanged: (newValue) => context.read<FieldVariableNumericCubit>().updateField(newValue),
        );
      },
    );
  }
}

class _TextVariable extends StatelessWidget {
  const _TextVariable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldVariableTextCubit, FieldVariableTextState>(
      builder: (context, state) {
        if (state.options == null || state.options!.isEmpty || !state.enabled) {
          return const _TextField();
        } else {
          return const _DropdownField();
        }
      },
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: context.read<FieldVariableTextCubit>().state.fieldValue),
      enabled: context.read<FieldVariableTextCubit>().state.enabled,
      onChanged: context.read<FieldVariableTextCubit>().updateField,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
   
  
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldVariableTextCubit, FieldVariableTextState>(
      builder: (context, state) {
        return DropdownButton<String>(
          value: state.fieldValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
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
