import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';

enum LossAddStates { lossSelection, lineUnitSelection, valueFill }

typedef LossAddCallback = Future<bool> Function(int productionBasicDataId, int lossCurrentDefinitionId, double lossValue, int lineUnitId);

class LossAdd extends StatefulWidget {
  const LossAdd({ Key? key, required this.lossOptions, required this.lineUnits, required this.lossAddCallback, required this.productionBasicId }) : super(key: key);

  final int productionBasicId;
  final List<Loss> lossOptions;
  final List<LineUnit> lineUnits;
  final LossAddCallback lossAddCallback;

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

      var possibleLineUnits = widget.lineUnits.where((lineUnit) => selectedLoss!.lineUnitLoss.contains(lineUnit.id)).toList();
      if (possibleLineUnits.length == 1) {
        selectedLineUnit = possibleLineUnits.first;
        lossAddStates = LossAddStates.valueFill;
      }
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
    return Column(
      children: [
        const SizedBox(height: 20),
        Text("CADASTRO DE PERDA", style: Theme.of(context).textTheme.headline6),
        Expanded(child: dialogBody()),
      ],
    );
  }

  Widget dialogBody() {
    switch (lossAddStates) {
      case LossAddStates.lossSelection:
        return lossSelection();
      case LossAddStates.lineUnitSelection:
        var lineUnits = widget.lineUnits.where((lineUnit) => selectedLoss!.lineUnitLoss.contains(lineUnit.id)).toList();
        return lineUnitSelection(lineUnits);
      case LossAddStates.valueFill:
        return valueFill();
    }
  }

  Widget valueFill() {
    return Column(
        children: [
          tipoPerdaSelecionada(),
          localSelecionado(),
          Container(
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: NumberInput(
              label: "Quantidade em " + selectedLoss!.unit, 
              value: lossValue, 
              allowDecimal: true,
              onChanged: (newValue) => setState(() {
                lossValue = newValue;
              })
            )
          ),
          flowControlButtons(),
        ],
      );
  }

  Widget lossSelection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: Text("Selecione a Perda", style: Theme.of(context).textTheme.titleMedium)
        ),
        Expanded(
          child: _ListOfLosses(
            losses: widget.lossOptions, 
            selectStopCallback: selectLoss
          ),
        ),
        flowControlButtons(),
      ],
    );
  }


  Widget lineUnitSelection(List<LineUnit> lineUnits) {
    return Column(
      children: [
        tipoPerdaSelecionada(),
        Container(
          padding: const EdgeInsets.all(15),
          child: Text("Selecione o local", style: Theme.of(context).textTheme.headline6)),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: lineUnits.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Card(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Text(lineUnits[index].name)
                  )
                ),
                onTap: () => selectLineUnit(lineUnits[index])
              );
            },
          )
        ),
        flowControlButtons(),
      ],
    );
  }

  Widget tipoPerdaSelecionada() {
    var textStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white);
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: Theme.of(context).primaryColor,
          
          borderOnForeground: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Row(
              children: [
                Text("Perda:", style: textStyle.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text(selectedLoss!.name + '(' + selectedLoss!.unit + ')', style: textStyle)
              ],
            ),
          )
        ),
      ),
      onTap: () => backToLossSelectionStage(),
    );
  }

  Widget localSelecionado() {
    var textStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white);
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: Theme.of(context).primaryColor,
          
          borderOnForeground: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Row(
              children: [
                Text("Local:", style: textStyle.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text(selectedLineUnit!.name, style: textStyle)
              ],
            ),
          )
        ),
      ),
      onTap: () => backToLineUnitSelectionStage(),
    );
  }

  void backOneStage() {
    if (lossAddStates == LossAddStates.lineUnitSelection) {
      backToLossSelectionStage();
    } else if (lossAddStates == LossAddStates.valueFill) {
      backToLineUnitSelectionStage();
    }
  }

  void backToLineUnitSelectionStage() {
    setState(() {
      lossAddStates = LossAddStates.lineUnitSelection;
      selectedLineUnit = null;
      lossValue = null;
    });
  }

  void backToLossSelectionStage() {
    setState(() {
      selectedLoss = null;
      lossAddStates = LossAddStates.lossSelection;
      selectedLineUnit = null;
      lossValue = null;
    });
  }

  Widget flowControlButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:  8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (lossAddStates != LossAddStates.lossSelection) 
            ...[ ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text("Voltar"),
              onPressed: () => backOneStage(),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary,
                minimumSize: const Size(1, 50)
              )
            ) ]
          else 
            ...[],
          if (lossAddStates == LossAddStates.valueFill)
            ...[ElevatedButton(
              child: const Text("Adicionar"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(1, 50),
                primary: Theme.of(context).colorScheme.primary
              ),
              onPressed: lossValue == null ? 
                null : 
                () async {
                var result = await widget.lossAddCallback(widget.productionBasicId, selectedLoss!.id, lossValue!, selectedLineUnit!.id);
                if (result) {
                  Navigator.pop(context);
                }
              }
            )]
          else
            ...[],
          ElevatedButton.icon(
            icon: const Icon(Icons.close),
            label: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(1, 50),
              primary: Theme.of(context).colorScheme.error
            )
          ),
        ]
      ),
    );
  }
}


typedef SelectLossCallback = Function(Loss loss);
class _ListOfLosses extends StatefulWidget {
  const _ListOfLosses({ Key? key, required List<Loss> losses, required SelectLossCallback selectStopCallback }) : _losses = losses, _selectLossCallback = selectStopCallback, super(key: key);

  final List<Loss> _losses;
  final SelectLossCallback _selectLossCallback;

  @override
  State<_ListOfLosses> createState() => _ListOfLossesState();
}

class _ListOfLossesState extends State<_ListOfLosses> {

  List<Loss> filteredLosses = List.empty();

  void _runFilter(String? searchValue) {

    var lcSearchValue = searchValue?.toLowerCase() ?? "";

    List<Loss> results;
    if (lcSearchValue.isEmpty) {
      results = widget._losses;
    } else {
      results = widget._losses
          .where((user) =>
              user.name.toLowerCase().contains(lcSearchValue))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

      // Refresh the UI
    setState(() {
      filteredLosses = results;
    });

  }

  @override
  void initState() {
    filteredLosses = widget._losses;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 500,
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))),
                labelText: 'Pesquisa', suffixIcon: Icon(Icons.search)
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        Expanded(
          child: filteredLosses.isEmpty
            ? const Text('Nenhum resultado', style: TextStyle(fontSize: 24))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredLosses.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    key: ValueKey(filteredLosses[index].id),
                    title: Card(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(filteredLosses[index].name)
                      )
                    ),
                    onTap: () => widget._selectLossCallback(filteredLosses[index])
                  );
                },
              ),
        ),
      ],
    );
  }
}