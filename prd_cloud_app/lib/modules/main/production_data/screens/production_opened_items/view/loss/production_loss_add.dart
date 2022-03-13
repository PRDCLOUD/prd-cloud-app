import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/widgets/number_input.dart';

enum LossAddStates { lossSelection, lineUnitSelection, valueFill }

typedef LossAdder = Future<bool> Function(int productionBasicDataId, int lossCurrentDefinitionId, double lossValue, int lineUnitId);

class LossAdd extends StatefulWidget {
  const LossAdd({ Key? key, required this.lossOptions, required this.lineUnits, required this.lossAdder, required this.productionBasicId }) : super(key: key);

  final int productionBasicId;
  final List<Loss> lossOptions;
  final List<LineUnit> lineUnits;
  final LossAdder lossAdder;

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
                var result = await widget.lossAdder(widget.productionBasicId, selectedLoss!.id, lossValue!, selectedLineUnit!.id);
                if (result) {
                  Navigator.pop(context);
                }
              }
            )
          ],
        );

    }
  }
}