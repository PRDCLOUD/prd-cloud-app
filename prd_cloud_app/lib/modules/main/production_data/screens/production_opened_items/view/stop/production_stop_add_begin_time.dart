import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/widgets/widgets.dart';

import 'production_stop_add.dart';

class StopBeginTime extends StatefulWidget {
  const StopBeginTime({ 
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
  State<StopBeginTime> createState() => _StopBeginTimeState();
}

class _StopBeginTimeState extends State<StopBeginTime> {

  DateTime? beginAtStopBeginAndTimeSpan;
  double? timeSpanAtStopBeginAndTimeSpan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [ const Text("Perda: "), Text(widget.selectedStop.name)]),
        Row(children: [ const Text("Local: "), Text(widget.selectedLineUnit.name)]),
        DateTimePicker(
          date: beginAtStopBeginAndTimeSpan,
          onChange: (newValue) {
            setState(() {
              beginAtStopBeginAndTimeSpan = newValue;
            });
          },
        ),
        NumberInput(
          label: "Tempo Total (min)",
          allowDecimal: true,
          value: timeSpanAtStopBeginAndTimeSpan,
          onChanged: (newValue) {
            setState(() {
              timeSpanAtStopBeginAndTimeSpan = newValue;
            });
          },
        ),
        ElevatedButton(
          child: const Text("Adicionar"),
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
          onPressed: beginAtStopBeginAndTimeSpan == null && timeSpanAtStopBeginAndTimeSpan != null && timeSpanAtStopBeginAndTimeSpan! > 0 ? 
            null : 
            () async {
              var result = await widget.stopAddCallback(
                lineUnitId: widget.selectedLineUnit.id,
                productionBasicDataId: widget.productionBasicId,
                stopCurrentDefinitionId: widget.selectedStop.id,
                stopType: widget.selectedStop.stopTypeOf,
                averageTimeAtStopQtyAverageTime: widget.selectedStop.averageTime,
                claims: widget.selectedStop.stopClaims,
                beginAtStopBeginAndTimeSpan: beginAtStopBeginAndTimeSpan,
                timeSpanAtStopBeginAndTimeSpan: timeSpanAtStopBeginAndTimeSpan
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