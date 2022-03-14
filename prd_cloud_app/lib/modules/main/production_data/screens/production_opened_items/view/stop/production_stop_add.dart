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

  void selectStop(Stop stop) {
    setState(() {
      selectedStop = stop;
      stopAddStates = StopAddStates.lineUnitSelection;
    });
  }

  void selectLineUnit(LineUnit lineUnit) {
    setState(() {
      selectedLineUnit = lineUnit;
      stopAddStates = StopAddStates.stopFill;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (stopAddStates) {
      case StopAddStates.stopSelection:
        return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.stopOptions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(widget.stopOptions[index].codeName),
                onTap: () => selectStop(widget.stopOptions[index]));
          },
        );
      case StopAddStates.lineUnitSelection:
        var lineUnits = widget.lineUnits
            .where(
                (lineUnit) => selectedStop!.lineUnitStops.contains(lineUnit.id))
            .toList();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: lineUnits.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(lineUnits[index].name),
                onTap: () => selectLineUnit(lineUnits[index]));
          },
        );
      case StopAddStates.stopFill:
        return BlocProvider(
          create: (context) => StopClaimCubit(stopClaims: selectedStop!.stopClaims),
          child: stopInformationFill(),
        );
    }
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
}
