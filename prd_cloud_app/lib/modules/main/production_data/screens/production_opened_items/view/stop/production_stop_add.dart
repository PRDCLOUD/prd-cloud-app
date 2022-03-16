import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/production_stop_add_begin_end.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/production_stop_add_begin_time.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/production_stop_add_qty_total_time.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/production_stop_add_total_time.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/stop_claim_cubit/stop_claim_cubit.dart';
import 'production_stop_add_qty_average.dart';

enum StopAddStates { stopSelection, lineUnitSelection, stopFill }

typedef StopAddCallback = Future<bool> Function(
    {required int productionBasicDataId,
    required int lineUnitId,
    required int stopCurrentDefinitionId,
    required StopTypeOf stopType,
    required List<StopClaim> claims,
    double? averageTimeAtStopQtyAverageTime,
    int? qtyAtStopQtyAverageTime,
    DateTime? beginAtStopBeginAndTimeSpan,
    double? timeSpanAtStopBeginAndTimeSpan,
    DateTime? beginAtStopBeginEnd,
    DateTime? endAtStopBeginEnd,
    int? qtyAtStopQtyTotalTime,
    double? totalTimeAtStopQtyTotalTime,
    double? stopTimeAtStopTimePerStop});

class StopAdd extends StatefulWidget {
  const StopAdd(
      {Key? key,
      required this.stopOptions,
      required this.lineUnits,
      required this.stopAddCallback,
      required this.productionBasicId})
      : super(key: key);

  final int productionBasicId;
  final List<Stop> stopOptions;
  final List<LineUnit> lineUnits;
  final StopAddCallback stopAddCallback;

  @override
  State<StopAdd> createState() => _StopAddState();
}

class _StopAddState extends State<StopAdd> {
  StopAddStates stopAddStates = StopAddStates.stopSelection;

  Stop? selectedStop;
  LineUnit? selectedLineUnit;



  @override
  Widget build(BuildContext context) {
    switch (stopAddStates) {
      case StopAddStates.stopSelection:
        return Column(
          children: [
            Expanded(child: _stopSelection()),
            flowControlButtons()
          ],
        );
      case StopAddStates.lineUnitSelection:
        
        return Column(
          children: [
            _selectedLossTopCard(),
            Expanded(child: _lineUnitSelection()),
            flowControlButtons()
          ],
        );
      case StopAddStates.stopFill:
        return BlocProvider(
          create: (context) => StopClaimCubit(stopClaims: selectedStop!.stopClaims),
          child: Column(
            children: [
              _selectedLossTopCard(),
              _selectedLineUnitCard(),
              stopInformationFill(),
              flowControlButtons()
            ],
          ),
        );
    }
  }

  ListView _lineUnitSelection() {
    var lineUnits = widget.lineUnits.where((lineUnit) => selectedStop!.lineUnitStops.contains(lineUnit.id)).toList();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: lineUnits.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(lineUnits[index].name),
              onTap: () => selectLineUnit(lineUnits[index]));
        },
      );
  }

  ListView _stopSelection() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.stopOptions.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(widget.stopOptions[index].codeName),
              onTap: () => selectStop(widget.stopOptions[index]));
        },
      );
  }

  void backOneStage() {
    if (stopAddStates == StopAddStates.lineUnitSelection) {
      backToStopSelectionStage();
    } else if (stopAddStates == StopAddStates.stopFill) {
      backToLineUnitSelectionStage();
    }
  }

  void backToStopSelectionStage() {
    setState(() {
      selectedStop = null;
      stopAddStates = StopAddStates.stopSelection;
      selectedLineUnit = null;
    });
  }

  void backToLineUnitSelectionStage() {
    setState(() {
      selectedLineUnit = null;
      stopAddStates = StopAddStates.lineUnitSelection;
    });
  }

  void selectStop(Stop stop) {
    setState(() {
      selectedStop = stop;
      stopAddStates = StopAddStates.lineUnitSelection;
      selectedLineUnit = null;
    });
  }

  void selectLineUnit(LineUnit lineUnit) {
    setState(() {
      selectedLineUnit = lineUnit;
      stopAddStates = StopAddStates.stopFill;
    });
  }

  Widget stopInformationFill() {
    switch (selectedStop!.stopTypeOf) {
      case StopTypeOf.QtyAverageTime:
        return StopQtyAverageTime(
            productionBasicId: widget.productionBasicId,
            selectedLineUnit: selectedLineUnit!,
            selectedStop: selectedStop!,
            stopAddCallback: widget.stopAddCallback);
      case StopTypeOf.QtyTotalTime:
        return StopQtyTotalTime(
            productionBasicId: widget.productionBasicId,
            selectedLineUnit: selectedLineUnit!,
            selectedStop: selectedStop!,
            stopAddCallback: widget.stopAddCallback);
      case StopTypeOf.TimeBegin:
        return StopBeginTime(
            productionBasicId: widget.productionBasicId,
            selectedLineUnit: selectedLineUnit!,
            selectedStop: selectedStop!,
            stopAddCallback: widget.stopAddCallback);
      case StopTypeOf.TimePerStop:
        return StopTimePerStop(
            productionBasicId: widget.productionBasicId,
            selectedLineUnit: selectedLineUnit!,
            selectedStop: selectedStop!,
            stopAddCallback: widget.stopAddCallback);
      case StopTypeOf.BeginEnd:
        return StopBeginEnd(
            productionBasicId: widget.productionBasicId,
            selectedLineUnit: selectedLineUnit!,
            selectedStop: selectedStop!,
            stopAddCallback: widget.stopAddCallback);
      default:
        throw Exception('Invalid StopTypeOf');
    }
  }

  Widget flowControlButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:  8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (stopAddStates != StopAddStates.stopSelection) 
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
          if (stopAddStates == StopAddStates.stopFill)
            ...[ElevatedButton(
              child: const Text("Adicionar"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(1, 50),
                primary: Theme.of(context).colorScheme.primary
              ),
              onPressed: () {} 
              // lossValue == null ? 
              //   null : 
              //   () async {
              //   var result = await widget.lossAddCallback(widget.productionBasicId, selectedLoss!.id, lossValue!, selectedLineUnit!.id);
              //   if (result) {
              //     Navigator.pop(context);
              //   }
              // }
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


  Widget _selectedLossTopCard() {
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
                Text(selectedStop!.codeName, style: textStyle)
              ],
            ),
          )
        ),
      ),
      onTap: () => backToStopSelectionStage(),
    );
  }

  Widget _selectedLineUnitCard() {
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

}
