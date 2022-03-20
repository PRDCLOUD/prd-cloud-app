import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';

import 'production_stop_add.dart';
import 'stop_add_cubit/stop_add_cubit.dart';
import 'stop_add_validation_cubit copy/stop_add_validation_cubit.dart';
import 'stop_claim_cubit/stop_claim_cubit.dart';

class StopTimePerStop extends StatefulWidget {
  const StopTimePerStop(
      {Key? key,
      required this.selectedStop,
      required this.selectedLineUnit,
      required this.stopAddCallback})
      : super(key: key);

  final Stop selectedStop;
  final ProductionLineUnit selectedLineUnit;
  final StopAddCallback stopAddCallback;

  @override
  State<StopTimePerStop> createState() => _StopTimePerStopState();
}

class _StopTimePerStopState extends State<StopTimePerStop> {
  double? stopTimeAtStopTimePerStop;

  bool isValid() => stopTimeAtStopTimePerStop != null;

  @override
  Widget build(BuildContext context) {
    context.read<StopAddValidationCubit>().timeValidationState(isValid());
    return BlocListener<StopAddCubit, DateTime>(
      listener: (context, state) async {
        var result = await widget.stopAddCallback(
            lineUnitId: widget.selectedLineUnit.lineUnitId,
            productionBasicDataId: widget.selectedLineUnit.productionBasicDataId,
            stopCurrentDefinitionId: widget.selectedStop.id,
            stopType: widget.selectedStop.stopTypeOf,
            averageTimeAtStopQtyAverageTime: widget.selectedStop.averageTime,
            stopTimeAtStopTimePerStop: stopTimeAtStopTimePerStop,
            claims: context.read<StopClaimCubit>().state.stopClaims
          );
        if (result) {
          Navigator.pop(context);
        }
      },
      child: Column(
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
        ],
      ),
    );
  }
}
