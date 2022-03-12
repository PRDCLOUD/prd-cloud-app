import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/field_begin_cubit/field_begin_cubit.dart';
import 'package:prd_cloud_app/modules/main/widgets/widgets.dart';


class ProductionDataEdit extends StatelessWidget {
  const ProductionDataEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FieldBeginCubit, FieldBeginState>(
          builder: (BuildContext context, state) {
            return DateTimePicker(date: state.fieldValue, onChange: (newValue) => context.read<FieldBeginCubit>().updateField(newValue));
          })
        );
  }
}

class _Begin extends StatelessWidget {
  const _Begin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FieldBeginCubit, FieldBeginState>(
          builder: (BuildContext context, state) {
            return DateTimePicker(date: state.fieldValue, onChange: (newValue) => context.read<FieldBeginCubit>().updateField(newValue));
          })
        );
  }
}

class _End extends StatelessWidget {
  const _Begin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FieldBeginCubit, FieldBeginState>(
          builder: (BuildContext context, state) {
            return DateTimePicker(date: state.fieldValue, onChange: (newValue) => context.read<FieldBeginCubit>().updateField(newValue));
          })
        );
  }
}
