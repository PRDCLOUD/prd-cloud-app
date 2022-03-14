import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/widgets/widgets.dart';

import 'production_stop_add.dart';

class StopQtyTotalTime extends StatefulWidget {
  const StopQtyTotalTime({ 
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
  State<StopQtyTotalTime> createState() => _StopQtyTotalTimeState();
}

class _StopQtyTotalTimeState extends State<StopQtyTotalTime> {

  double? qtyAtStopQtyTotalTime;
  double? totalTimeAtStopQtyTotalTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [ const Text("Perda: "), Text(widget.selectedStop.name)]),
        Row(children: [ const Text("Local: "), Text(widget.selectedLineUnit.name)]),
        NumberInput(
          label: "Quantidade",
          allowDecimal: false,
          value: qtyAtStopQtyTotalTime,
          onChanged: (newValue) {
            setState(() {
              qtyAtStopQtyTotalTime = newValue;
            });
          },
        ),
        NumberInput(
          label: "Tempo Total (min)",
          allowDecimal: true,
          value: totalTimeAtStopQtyTotalTime,
          onChanged: (newValue) {
            setState(() {
              totalTimeAtStopQtyTotalTime = newValue;
            });
          },
        ),
        ElevatedButton(
          child: const Text("Adicionar"),
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
          onPressed: qtyAtStopQtyTotalTime == null && totalTimeAtStopQtyTotalTime != null ? 
            null : 
            () async {
              var result = await widget.stopAddCallback(
                lineUnitId: widget.selectedLineUnit.id,
                productionBasicDataId: widget.productionBasicId,
                stopCurrentDefinitionId: widget.selectedStop.id,
                stopType: widget.selectedStop.stopTypeOf,
                averageTimeAtStopQtyAverageTime: widget.selectedStop.averageTime,
                claims: widget.selectedStop.stopClaims,
                qtyAtStopQtyTotalTime: qtyAtStopQtyTotalTime!.toInt(),
                totalTimeAtStopQtyTotalTime: totalTimeAtStopQtyTotalTime
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