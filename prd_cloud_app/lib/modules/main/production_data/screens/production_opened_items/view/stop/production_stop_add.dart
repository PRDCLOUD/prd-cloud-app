import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/widgets/number_input.dart';

enum StopAddStates { stopSelection, lineUnitSelection, valueFill }

typedef StopAdder = Future<bool> Function({
    required int productionBasicDataId, 
    required int lineUnitId, 
    required int stopCurrentDefinitionId,
    required String stopType,
    required List<StopClaim> claims, 
    double? averageTimeAtStopQtyAverageTime, 
    int? qtyAtStopQtyAverageTime,
    DateTime? beginAtStopBeginAndTimeSpan,
    double? timeSpanAtStopBeginAndTimeSpan,
    DateTime? beginAtStopBeginEnd,
    DateTime? endAtStopBeginEnd,
    int? qtyAtStopQtyTotalTime,
    double? totalTimeAtStopQtyTotalTime,
    double? stopTimeAtStopTimePerStop
  });

class StopAdd extends StatefulWidget {
  const StopAdd({ Key? key, required this.stopOptions, required this.lineUnits, required this.stopAdder, required this.productionBasicId }) : super(key: key);

  final int productionBasicId;
  final List<Stop> stopOptions;
  final List<LineUnit> lineUnits;
  final StopAdder stopAdder;

  @override
  State<StopAdd> createState() => _StopAddState();
}

class _StopAddState extends State<StopAdd> {

  StopAddStates lossAddStates = StopAddStates.stopSelection;

  Stop? selectedStop;
  LineUnit? selectedLineUnit;
  double? lossValue;

  void selectStop(Stop stop) {
    setState(() {
      selectedStop = stop;
      lossAddStates = StopAddStates.lineUnitSelection;
    });
  }

  void selectLineUnit(LineUnit lineUnit) {
    setState(() {
      selectedLineUnit = lineUnit;
      lossAddStates = StopAddStates.valueFill;
    });
  }

  void fillStopValue(double? value) {
    lossValue = value;
  }

  @override
  Widget build(BuildContext context) {
    switch (lossAddStates) {
      case StopAddStates.stopSelection:
        return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.stopOptions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(widget.stopOptions[index].name),
              onTap: () => selectStop(widget.stopOptions[index])
            );
          },
        );
      case StopAddStates.lineUnitSelection:
        var lineUnits = widget.lineUnits.where((lineUnit) => selectedStop!.lineUnitStops.contains(lineUnit.id)).toList();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: lineUnits.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(lineUnits[index].name),
              onTap: () => selectLineUnit(lineUnits[index])
            );
          },
        );
      case StopAddStates.valueFill:
        return Column(
          children: [
            Row(children: [ const Text("Perda: "), Text(selectedStop!.name)]),
            Row(children: [ const Text("Local: "), Text(selectedLineUnit!.name)]),
            NumberInput(
              label: "Quantidade", 
              value: lossValue, 
              allowDecimal: true,
              onChanged: (newValue) => setState(() {
                lossValue = newValue;
              })
            ),
            ElevatedButton(
              child: const Text("Adicionar"),
              style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
              onPressed: lossValue == null ? 
                null : 
                () async {
                // var result = await widget.stopAdder(widget.productionBasicId, selectedLoss!.id, lossValue!, selectedLineUnit!.id);
                // if (result) {
                  Navigator.pop(context);
                // }
              }
            )
          ],
        );

    }
  }
}