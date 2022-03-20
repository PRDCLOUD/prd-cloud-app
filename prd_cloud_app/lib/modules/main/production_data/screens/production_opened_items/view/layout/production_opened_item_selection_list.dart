import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/bloc/main_bloc.dart';
import 'package:prd_cloud_app/theme.dart';

class ProductionOpenedItemSelectionListPage extends StatelessWidget {
  const ProductionOpenedItemSelectionListPage({Key? key, required OpenProductionDataCubit openProductionDataCubit, required SelectedProductionDataCubit selectedProductionDataCubit}) 
    : _openProductionDataCubit = openProductionDataCubit, _selectedProductionDataCubit = selectedProductionDataCubit, super(key: key);

  final OpenProductionDataCubit _openProductionDataCubit;
  final SelectedProductionDataCubit _selectedProductionDataCubit;

  static MaterialPageRoute<void> route(OpenProductionDataCubit openProductionDataCubit, SelectedProductionDataCubit selectedProductionDataCubit) => MaterialPageRoute(
    builder: (_) => ProductionOpenedItemSelectionListPage(openProductionDataCubit: openProductionDataCubit, selectedProductionDataCubit: selectedProductionDataCubit),
  );

  selectProductionData(BuildContext context, ProductionDataGroup productionGroup) {
    _selectedProductionDataCubit.selectProductionDataGroup(productionGroup.getId());
    Navigator.pop(context);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Apontamentos em aberto"),
        
      ),
      body: ListView.builder(
          itemCount: _openProductionDataCubit.state.loadedItems.length,
          itemBuilder: (BuildContext context, int index) {
            return _ProductionSummary(
              key: ValueKey(_openProductionDataCubit.state.loadedItems[index].getId()),
              productionGroup: _openProductionDataCubit.state.loadedItems[index],
              isSelected: _selectedProductionDataCubit.state == _openProductionDataCubit.state.loadedItems[index].getId(),
              onTap: () => { selectProductionData(context, _openProductionDataCubit.state.loadedItems[index]) },
            );
          }
        )
      );
  }
}

class _ProductionSummary extends StatefulWidget {
  const _ProductionSummary({Key? key, required ProductionDataGroup productionGroup, required bool isSelected, required void Function()? onTap}) 
  : _productionData = productionGroup, 
    _isSelected = isSelected, 
    _onTap = onTap,
    super(key: key);

  final ProductionDataGroup _productionData;
  final bool _isSelected;
  final void Function()? _onTap;

  @override
  State<_ProductionSummary> createState() => _ProductionSummaryState();
}

class _ProductionSummaryState extends State<_ProductionSummary> {
  @override
  Widget build(BuildContext context) {
    return card();
  }

  String dateTimeAsString(DateTime? date) {
    if (date == null) {
      return "";
    } else {
      return DateFormat.yMd(Localizations.localeOf(context).languageCode).add_jm().format(date);
    }
  } 

  Card card() {
      
    var title = Theme.of(context).textTheme.titleLarge!;
    var bodyMedium = Theme.of(context).textTheme.bodyMedium!;

    if (widget._isSelected) {
      title = title.copyWith(color: Colors.white);
      bodyMedium = bodyMedium.copyWith(color: Colors.white);
    }

    return Card(
      shape: AppTheme.cardShape,
      key: ValueKey("ProductionSummaryCard_" + widget._productionData.getId().toString()),
      color: widget._isSelected ? Theme.of(context).primaryColor : null,
      child: InkWell(
        onTap: widget._onTap,
        child: Container(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [ 
                        Text(widget._productionData.productionDataGroup.first.getProductionLine().name, style: title.copyWith(fontWeight: FontWeight.normal)),
                        Text("#" + widget._productionData.getId().toString(), style: title.copyWith(fontWeight: FontWeight.normal))
                      ] 
                    ),
                    // if (widget._productionData.productId == null) 
                    //   ...[]
                    // else ...[
                    //   Padding(
                    //     padding: const EdgeInsets.only(left: 7.0),
                    //     child: Row(children: [ Text(widget._productionData.getSelectedProduct()!.name, style: bodyMedium) ] ),
                    //   )
                    // ],
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(children: [ Text("Início: ", style: bodyMedium), Text(dateTimeAsString(widget._productionData.productionDataGroup.first.begin), style: bodyMedium) ] ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(children: [ Text("Fim: ", style: bodyMedium), Text(dateTimeAsString(widget._productionData.productionDataGroup.first.end), style: bodyMedium) ] ),
                    ),
                  ]
                )
              ),
            ]
          ),
        ),
      )
    );
  }
}