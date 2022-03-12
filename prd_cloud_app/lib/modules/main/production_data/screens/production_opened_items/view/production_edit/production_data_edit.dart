import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/modules/main/widgets/widgets.dart';


class ProductionDataEdit extends StatelessWidget {
  const ProductionDataEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [ 
                  Row(
                    children: const [ 
                      _Begin(),
                      _End(),
                    ]
                  ),
                  _Comments()
                ],
              ),
            ),
          );
        },
      );
  }
}

class _Begin extends StatelessWidget {
  const _Begin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldBeginCubit, FieldBeginState>(
      builder: (BuildContext context, state) {
        return DateTimePicker(date: state.fieldValue, onChange: (newValue) => context.read<FieldBeginCubit>().updateField(newValue));
      }
    );
  }
}

class _End extends StatelessWidget {
  const _End({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldEndCubit, FieldEndState>(
      builder: (BuildContext context, state) {
        return DateTimePicker(date: state.fieldValue, onChange: (newValue) => context.read<FieldEndCubit>().updateField(newValue));
      }
    );
  }
}

class _Comments extends StatelessWidget {
  const _Comments({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldCommentsCubit, FieldCommentsState>(
      builder: (BuildContext context, state) {
        return TextAreaInput(initialValue: state.fieldValue, onChange: (newValue) => context.read<FieldCommentsCubit>().updateField(newValue));
      }
    );  
  }
}
