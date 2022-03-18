import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';

import 'product_selection_page.dart';
import 'production_variable_edit.dart';

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
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: _Begin(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                    child: _End(),
                  ),
                ]),
                const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: _Comments(),
                ),
                const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: _Products(),
                ),
                ...getVariableWidgets(context)
              ],
            ),
          ),
        );
      },
    );
  }

  List<_VariableLineUnit> getVariables(ProductionBasicData productionBasicData) {
    var variablesLineUnit = List<_VariableLineUnit>.empty(growable: true);
    for (var productionLineUnit in productionBasicData.lineUnits) { 
      if (productionLineUnit.lineUnit.productionVariables.isNotEmpty) {
        var rows = groupBy(productionLineUnit.lineUnit.productionVariables, (ProductionVariable x) => x.rowOrder)
                        .entries.map((rowItem) { 
                          var columns = rowItem.value.map((e) => _ColumnVariableLineUnit(e.columnOrder, e.width, e)).toList();
                          return _RowVariableLineUnit(rowItem.key, productionLineUnit, columns);
                        }).toList();

        variablesLineUnit.add(_VariableLineUnit(productionLineUnit, rows));
      }
    }
    return variablesLineUnit;
  }

  List<Widget> getVariableWidgets(BuildContext context) {

    var productionDataId = context.read<SelectedProductionDataCubit>().state as int;

    var productionData = context
        .read<OpenProductionDataCubit>()
        .state
        .loadedItems
        .firstWhere((element) => element.id == productionDataId);

    var variableLineUnits = getVariables(productionData);

    var widgetRows = List<Widget>.empty(growable: true);

    for(var lineUnits in variableLineUnits) {
      for(var row in lineUnits.rows) {
        for(var column in row.columns) {
          widgetRows.add(
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: ProductionVariableEdit(productionVariable: column.productionVariable),
            )
          );
        }
      }
    }

    return widgetRows;
  }
}

class _Begin extends StatelessWidget {
  const _Begin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldBeginCubit, FieldBeginState>(
      builder: (BuildContext context, state) {
        return DateTimePicker(
          key: const ValueKey("Início"),
          label: "Início",
          locale: Localizations.localeOf(context),
          date: state.fieldValue,
          onChange: (newValue) => context.read<FieldBeginCubit>().updateField(newValue)
        );
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
        return DateTimePicker(
          key: const ValueKey("Fim"),
          label: "Fim",
          locale: Localizations.localeOf(context),
          date: state.fieldValue,
          onChange: (newValue) => context.read<FieldEndCubit>().updateField(newValue)
        );
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
          return TextFormField(
            initialValue: state.fieldValue,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            onChanged: (newValue) => context.read<FieldCommentsCubit>().updateField(newValue),
            decoration: const InputDecoration(
              label: Text("Comentário"),
            ),
          );
        }
      );
  }
}


class _Products extends StatelessWidget {
  const _Products({Key? key}) : super(key: key);

  void productSelection({required BuildContext context, required List<Product> products, required ProductSetter onChange, required int? selectedProductId}) {
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => 
        ProductSelectionPage(
          products: products, 
          onChange: onChange,
          selectedProductId: selectedProductId,
          )
        )
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
        return InkWell(
          key: ValueKey("Product_Id_" + (state.fieldValue?.toString() ?? "")),
          onTap: () => productSelection(
            context: context, 
            selectedProductId: state.fieldValue,
            products: products, 
            onChange: context.read<FieldProductCubit>().updateField
          ),
          child: TextFormField(
            initialValue: state.fieldValue == null ? null : products.firstWhere((element) => element.id == state.fieldValue).name,
            enabled: false,
            decoration: InputDecoration(
              label: Text("Produto", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black54),),
            ).copyWith(
              disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
            ),
          )
        );
      },
    );
  }
  
}




class _VariableLineUnit {
  final ProductionLineUnit productionLineUnit;
  final List<_RowVariableLineUnit> rows;

  _VariableLineUnit(this.productionLineUnit, this.rows);
}

class _RowVariableLineUnit {
  final int row;
  final ProductionLineUnit productionLineUnit;
  final List<_ColumnVariableLineUnit> columns;

  _RowVariableLineUnit(this.row, this.productionLineUnit, this.columns);
}

class _ColumnVariableLineUnit {
  final int column;
  final int width;
  final ProductionVariable productionVariable;

  _ColumnVariableLineUnit(this.column, this.width, this.productionVariable);
}