import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
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
                Row(children: const [
                  _Begin(),
                  _End(),
                ]),
                _Comments(),
                _Products()
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
      return DateTimePicker(
          date: state.fieldValue,
          onChange: (newValue) =>
              context.read<FieldBeginCubit>().updateField(newValue));
    });
  }
}

class _End extends StatelessWidget {
  const _End({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldEndCubit, FieldEndState>(
        builder: (BuildContext context, state) {
      return DateTimePicker(
          date: state.fieldValue,
          onChange: (newValue) =>
              context.read<FieldEndCubit>().updateField(newValue));
    });
  }
}

class _Comments extends StatelessWidget {
  const _Comments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldCommentsCubit, FieldCommentsState>(
        builder: (BuildContext context, state) {
      return TextAreaInput(
          initialValue: state.fieldValue,
          onChange: (newValue) =>
              context.read<FieldCommentsCubit>().updateField(newValue));
    });
  }
}

typedef ProductSetter = void Function(int? newValue);
class _Products extends StatelessWidget {
  const _Products({Key? key}) : super(key: key);

  Future<void> productSelection(BuildContext context, List<Product> products, ProductSetter onChange) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Produtos:'),
          content: setupAlertDialoadContainer(context, products, onChange),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var selectedProductionDataId = context.read<SelectedProductionDataCubit>().state;
    
    var selectedProductionData = context
        .read<OpenProductionDataCubit>()
        .state
        .loadedItems
        .firstWhere((element) => element.id == selectedProductionDataId);

    var products = selectedProductionData.products;

    return BlocBuilder<FieldProductCubit, FieldProductState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => productSelection(context, products, context.read<FieldProductCubit>().updateField),
          child: state.fieldValue == null ? 
                  const Text('<selectionar produto>') : 
                  Text(products.firstWhere((element) => element.id == state.fieldValue).name)
        );
      },
    );
  }

  
  Widget setupAlertDialoadContainer(BuildContext context, List<Product> products, ProductSetter onChange) {

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(products[index].name),
            onTap: () { 
              onChange(products[index].id);
              Navigator.pop(context);
            }
          );
        },
      ),
    );
  }
}
