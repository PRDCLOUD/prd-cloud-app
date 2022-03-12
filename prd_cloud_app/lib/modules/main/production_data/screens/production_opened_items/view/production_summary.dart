import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductionSummary extends StatelessWidget {
  const ProductionSummary({Key? key, required ProductionBasicData productionData}) : _productionData = productionData, super(key: key);

  final ProductionBasicData _productionData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_productionData.id.toString()),
        Row(children: [                
          Text("Begin: " + (_productionData.begin?.toIso8601String() ?? "")),
          Text("End: " + (_productionData.end?.toIso8601String() ?? ""))],
        ),
        Row(children: [
          Text(_productionData.lineUnits.first.name)
        ])
      ],
    );
  }
}