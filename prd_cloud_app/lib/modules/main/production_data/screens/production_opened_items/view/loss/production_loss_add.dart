import 'package:flutter/material.dart';
import 'package:models/models.dart';

enum LossAddStates { lossSelection, lineUnitSelection, valueFill }

class LossAdd extends StatefulWidget {
  const LossAdd({ Key? key, required this.lossOptions, required this.lineUnits }) : super(key: key);

  final List<Loss> lossOptions;
  final List<LineUnit> lineUnits;

  @override
  State<LossAdd> createState() => _LossAddState();
}

class _LossAddState extends State<LossAdd> {

  LossAddStates lossAddStates = LossAddStates.lossSelection;

  Loss? selectedLoss;
  LineUnit? selectedLineUnit;
  double? lossValue;

  void selectLoss(Loss loss) {
    setState(() {
      selectedLoss = loss;
      lossAddStates = LossAddStates.lineUnitSelection;
    });
  }

  void selectLineUnit(LineUnit lineUnit) {
    setState(() {
      selectedLineUnit = lineUnit;
      lossAddStates = LossAddStates.valueFill;
    });
  }

  void fillLossValue(double? value) {
    lossValue = value;
  }

  @override
  Widget build(BuildContext context) {
    switch (lossAddStates) {
      case LossAddStates.lossSelection:
        return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.lossOptions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(widget.lossOptions[index].name),
              onTap: () => selectLoss(widget.lossOptions[index])
            );
          },
        );
      case LossAddStates.lineUnitSelection:
        var lineUnits = widget.lineUnits.where((lineUnit) => selectedLoss!.lineUnitLoss.contains(lineUnit.id)).toList();
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
      case LossAddStates.valueFill:
        return Column(
          children: [
            Row(children: [ const Text("Perda: "), Text(selectedLoss!.name)]),
            Row(children: [ const Text("Local: "), Text(selectedLineUnit!.name)])
          ],
        );

    }
  }
}