import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';

import 'production_stop_add.dart';

class StopTimePerStop extends StatefulWidget {
  const StopTimePerStop({ 
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
  State<StopTimePerStop> createState() => _StopTimePerStopState();
}

class _StopTimePerStopState extends State<StopTimePerStop> {

  double? stopTimeAtStopTimePerStop;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberInput(
          label: "Tempo Total (min)",
          allowDecimal: true,
          value: stopTimeAtStopTimePerStop,
          onChanged: (newValue) {
            setState(() {
              stopTimeAtStopTimePerStop = newValue;
            });
          },
        ),
        ElevatedButton(
          child: const Text("Adicionar"),
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
          onPressed: stopTimeAtStopTimePerStop != null ? 
            null : 
            () async {
              var result = await widget.stopAddCallback(
                lineUnitId: widget.selectedLineUnit.id,
                productionBasicDataId: widget.productionBasicId,
                stopCurrentDefinitionId: widget.selectedStop.id,
                stopType: widget.selectedStop.stopTypeOf,
                averageTimeAtStopQtyAverageTime: widget.selectedStop.averageTime,
                claims: widget.selectedStop.stopClaims,
                stopTimeAtStopTimePerStop: stopTimeAtStopTimePerStop
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