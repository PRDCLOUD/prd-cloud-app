import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductionSelectedSummary extends StatelessWidget {
  const ProductionSelectedSummary({Key? key, required ProductionBasicData productionData}) : _productionData = productionData, super(key: key);

  final ProductionBasicData _productionData;

  @override
  Widget build(BuildContext context) {

    var productionLine = _productionData.lineUnits.firstWhere((e) => e.type == 'ProductionLine');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(child: 
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
                  onPressed: () {},
                  child: Row(
                    children: [ 
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ID " + _productionData.id.toString(), style: Theme.of(context).textTheme.headline6,),
                            Row(children: [
                              Text("Linha: " + productionLine.name, style: Theme.of(context).textTheme.bodyLarge)
                            ])
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_drop_down_sharp)
                    ],
                  ),
                )
              ),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  child: const Icon(Icons.check),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(56, 118, 29, 1),
                    fixedSize: const Size(60, 60)
                  ),
                  onPressed: () {}),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  child: const Icon(Icons.close),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.secondary,
                    fixedSize: const Size(60, 60)
                  ),
                  onPressed: () {}),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: ElevatedButton(
                  child: const Icon(Icons.delete_outline),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.error,
                    fixedSize: const Size(60, 60)
                  ),
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}