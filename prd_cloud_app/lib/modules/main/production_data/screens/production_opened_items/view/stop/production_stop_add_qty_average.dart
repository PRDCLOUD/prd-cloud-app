import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';

import 'production_stop_add.dart';

class StopQtyAverageTime extends StatefulWidget {
  const StopQtyAverageTime({ 
    Key? key, 
    required this.productionBasicId,
    required this.selectedStop,
    required this.selectedLineUnit,
    required this.stopAddCallback
  }) : super(key: key);

  final int productionBasicId;
  final Stop selectedStop;
  final LineUnit selectedLineUnit;
  final StopAddCallback stopAddCallback;
  
  @override
  State<StopQtyAverageTime> createState() => _StopQtyAverageTimeState();
}

class _StopQtyAverageTimeState extends State<StopQtyAverageTime> {

  double? qtyAtStopQtyAverageTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [ const Text("Perda: "), Text(widget.selectedStop.name)]),
        Row(children: [ const Text("Local: "), Text(widget.selectedLineUnit.name)]),
        NumberInput(
          label: "Quantidade",
          allowDecimal: false,
          value: qtyAtStopQtyAverageTime,
          onChanged: (newValue) {
            setState(() {
              qtyAtStopQtyAverageTime = newValue;
            });
          },
        ),
        ElevatedButton(
          child: const Text("Adicionar"),
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
          onPressed: qtyAtStopQtyAverageTime == null ? 
            null : 
            () async {
              var result = await widget.stopAddCallback(
                lineUnitId: widget.selectedLineUnit.id,
                productionBasicDataId: widget.productionBasicId,
                stopCurrentDefinitionId: widget.selectedStop.id,
                stopType: widget.selectedStop.stopTypeOf,
                qtyAtStopQtyAverageTime: qtyAtStopQtyAverageTime!.toInt(),
                averageTimeAtStopQtyAverageTime: widget.selectedStop.averageTime,
                claims: widget.selectedStop.stopClaims
              );
              if (result) {
                Navigator.pop(context);
              }
            }
          )
      ],
    );
  }
}
