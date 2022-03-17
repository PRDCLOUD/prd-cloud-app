import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:models/models.dart';

class ProductionSummary extends StatefulWidget {
  const ProductionSummary({Key? key, required ProductionBasicData productionData, required bool isSelected, required void Function()? onTap}) 
  : _productionData = productionData, 
    _isSelected = isSelected, 
    _onTap = onTap,
    super(key: key);

  final ProductionBasicData _productionData;
  final bool _isSelected;
  final void Function()? _onTap;

  @override
  State<ProductionSummary> createState() => _ProductionSummaryState();
}

class _ProductionSummaryState extends State<ProductionSummary> {
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
      key: ValueKey("ProductionSummaryCard_" + widget._productionData.id.toString()),
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
                        Text(widget._productionData.getProductionLine().name, style: title.copyWith(fontWeight: FontWeight.normal)),
                        Text("#" + widget._productionData.id.toString(), style: title.copyWith(fontWeight: FontWeight.normal))
                      ] 
                    ),
                    if (widget._productionData.productId == null) 
                      ...[]
                    else ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: Row(children: [ Text(widget._productionData.getSelectedProduct()!.name, style: bodyMedium) ] ),
                      )
                    ],
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(children: [ Text("Início: ", style: bodyMedium), Text(dateTimeAsString(widget._productionData.begin), style: bodyMedium) ] ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(children: [ Text("Fim: ", style: bodyMedium), Text(dateTimeAsString(widget._productionData.end), style: bodyMedium) ] ),
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