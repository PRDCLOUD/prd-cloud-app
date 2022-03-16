import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';

import 'production_stop_add.dart';
import 'production_stop_claim.dart';

class StopBeginEnd extends StatefulWidget {
  StopBeginEnd({ 
    Key? key, 
    required this.productionBasicId,
    required this.selectedStop,
    required this.selectedLineUnit,
    required this.stopAddCallback
  }) : super(key: key) {
    editableStopClaim = selectedStop.stopClaims.map((e) => EditableStopClaim(e)).toList();
  }

  final int productionBasicId;
  final Stop selectedStop;
  final LineUnit selectedLineUnit;
  final StopAddCallback stopAddCallback;

  late List<EditableStopClaim> editableStopClaim;

  @override
  State<StopBeginEnd> createState() => _StopBeginEndState();
}

class _StopBeginEndState extends State<StopBeginEnd> {

  DateTime? beginAtStopBeginEnd;
  DateTime? endAtStopBeginEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [ const Text("Perda: "), Text(widget.selectedStop.name)]),
        Row(children: [ const Text("Local: "), Text(widget.selectedLineUnit.name)]),
        DateTimePicker(
          label: "Início",
          locale: Localizations.localeOf(context),
          date: beginAtStopBeginEnd,
          onChange: (newValue) {
            setState(() {
              beginAtStopBeginEnd = newValue;
            });
          },
        ),
        DateTimePicker(
          label: "Fim",
          locale: Localizations.localeOf(context),
          date: endAtStopBeginEnd,
          onChange: (newValue) {
            setState(() {
              endAtStopBeginEnd = newValue;
            });
          },
        ),
        ElevatedButton(
          child: const Text("Adicionar"),
          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
          onPressed: (beginAtStopBeginEnd == null || endAtStopBeginEnd == null || endAtStopBeginEnd!.isAtSameMomentAs(beginAtStopBeginEnd!) || endAtStopBeginEnd!.isBefore(beginAtStopBeginEnd!)) ? 
            null : 
            () async {
              var result = await widget.stopAddCallback(
                lineUnitId: widget.selectedLineUnit.id,
                productionBasicDataId: widget.productionBasicId,
                stopCurrentDefinitionId: widget.selectedStop.id,
                stopType: widget.selectedStop.stopTypeOf,
                averageTimeAtStopQtyAverageTime: widget.selectedStop.averageTime,
                claims: widget.selectedStop.stopClaims,
                beginAtStopBeginEnd: beginAtStopBeginEnd,
                endAtStopBeginEnd: endAtStopBeginEnd
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
