import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/theme.dart';
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
                    padding: EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 5.0, top: 2.0),
                    child: _Begin(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 5.0, top: 2.0),
                    child: _End(),
                  ),
                ]),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: _Comments(),
                ),
                ...getProductAndVariableWidgets(context)
              ],
            ),
          ),
        );
      },
    );
  }

  List<_VariableLineUnit> getVariables(ProductionDataGroup productionGroup) {
    var variablesLineUnit = List<_VariableLineUnit>.empty(growable: true);
    for (var productionData in productionGroup.productionDataGroup) {
      for (var productionLineUnit in productionData.lineUnits) {
        if (productionLineUnit.lineUnit.productionVariables.isNotEmpty) {
          var rows = groupBy(productionLineUnit.lineUnit.productionVariables,
              (ProductionVariable x) => x.rowOrder).entries.map((rowItem) {
            var columns = rowItem.value
                .map((e) => _ColumnVariableLineUnit(e.columnOrder, e.width, e))
                .toList();
            return _RowVariableLineUnit(
                rowItem.key, productionLineUnit, columns);
          }).toList();

          variablesLineUnit.add(_VariableLineUnit(productionLineUnit, rows));
        }
      }
    }
    return variablesLineUnit;
  }

  List<Widget> getProductAndVariableWidgets(BuildContext context) {
    var productionDataId =
        context.read<SelectedProductionDataCubit>().state as int;

    var productionData = context
        .read<OpenProductionDataCubit>()
        .state
        .loadedItems
        .firstWhere((element) => element.hasProductionData(productionDataId));

    var variableLineUnits = getVariables(productionData);

    var widgetRows = List<Widget>.empty(growable: true);

    for (var lineUnit in variableLineUnits) {
      var cardWidgets = List<Widget>.empty(growable: true);

      if (lineUnit.productionLineUnit.isProductionLine()) {
        cardWidgets.add(Padding(
          padding: const EdgeInsets.all(5.0),
          child: _ProductsCubitProvider(productionBasicDataId: lineUnit.productionLineUnit.productionBasicDataId),
        ));
      }

      for (var row in lineUnit.rows) {
        for (var column in row.columns) {
          cardWidgets.add(Padding(
            padding: const EdgeInsets.all(5.0),
            child: ProductionVariableEdit(
                productionVariable: column.productionVariable),
          ));
        }
      }
      var card = Card(
          shape: AppTheme.cardShape,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                lineUnit.productionLineUnit.name,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              ...cardWidgets
            ]),
          ));

      widgetRows.add(card);
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
          key: const ValueKey("Fim"),
          label: "Fim",
          locale: Localizations.localeOf(context),
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
      return TextFormField(
        initialValue: state.fieldValue,
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        onChanged: (newValue) =>
            context.read<FieldCommentsCubit>().updateField(newValue),
        decoration: const InputDecoration(
          label: Text("Comentário"),
        ),
      );
    });
  }
}

class _ProductsCubitProvider extends StatelessWidget {
  const _ProductsCubitProvider({Key? key, required this.productionBasicDataId})
      : super(key: key);

  final int productionBasicDataId;

  @override
  Widget build(BuildContext context) {
    var selectedProductionGroup = context
        .read<OpenProductionDataCubit>()
        .state
        .loadedItems
        .firstWhere((e) => e.hasProductionData(productionBasicDataId));

    var productionData = selectedProductionGroup.productionDataGroup
        .firstWhere((e) => e.id == productionBasicDataId);
    return BlocProvider(
      create: (context) => FieldProductCubit(openProductionDataRepository: context.read(), productionBasicDataId: productionBasicDataId, initialValue: productionData.productId),
      child: _Products(productionBasicDataId: productionBasicDataId),
    );
  }
}

class _Products extends StatelessWidget {
  const _Products({Key? key, required this.productionBasicDataId})
      : super(key: key);

  final int productionBasicDataId;

  void productSelection({required BuildContext context,
                          required List<Product> products,
                          required ProductSetter onChange,
                          required int? selectedProductId
                        }) {
    FocusScope.of(context).unfocus();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductSelectionPage(
                  products: products,
                  onChange: onChange,
                  selectedProductId: selectedProductId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    var selectedProductionGroup = context
        .read<OpenProductionDataCubit>()
        .state
        .loadedItems
        .firstWhere(
            (element) => element.hasProductionData(productionBasicDataId));

    var productionData = selectedProductionGroup.productionDataGroup
        .firstWhere((e) => e.id == productionBasicDataId);

    var products = productionData.products;

    return BlocBuilder<FieldProductCubit, FieldProductState>(
      builder: (context, state) {
        return InkWell(
            key: ValueKey("Product_Id_" +
                productionBasicDataId.toString() +
                "_" +
                (state.fieldValue?.toString() ?? "")),
            onTap: () => productSelection(
                context: context,
                selectedProductId: state.fieldValue,
                products: products,
                onChange: context.read<FieldProductCubit>().updateField),
            child: TextFormField(
              initialValue: state.fieldValue == null
                  ? null
                  : products
                      .firstWhere((element) => element.id == state.fieldValue)
                      .name,
              enabled: false,
              decoration: InputDecoration(
                label: Text(
                  "Produto",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black54),
                ),
              ).copyWith(
                disabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54)),
              ),
            ));
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
