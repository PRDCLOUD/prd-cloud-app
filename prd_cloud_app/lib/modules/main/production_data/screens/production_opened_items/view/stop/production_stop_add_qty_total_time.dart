import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:prd_cloud_app/modules/main/production_data/screens/production_opened_items/view/stop/stop_claim_cubit/stop_claim_cubit.dart';
import 'package:prd_cloud_app/widgets/widgets.dart';

import 'production_stop_add.dart';
import 'production_stop_claim.dart';
import 'stop_add_cubit/stop_add_cubit.dart';
import 'stop_add_validation_cubit copy/stop_add_validation_cubit.dart';

class StopQtyTotalTime extends StatefulWidget {
  const StopQtyTotalTime(
      {Key? key,
      required this.productionBasicId,
      required this.selectedStop,
      required this.selectedLineUnit,
      required this.stopAddCallback})
      : super(key: key);

  final int productionBasicId;
  final Stop selectedStop;
  final LineUnit selectedLineUnit;
  final StopAddCallback stopAddCallback;

  @override
  State<StopQtyTotalTime> createState() => _StopQtyTotalTimeState();
}

class _StopQtyTotalTimeState extends State<StopQtyTotalTime> {
  double? qtyAtStopQtyTotalTime;
  double? totalTimeAtStopQtyTotalTime;

  bool isValid() => qtyAtStopQtyTotalTime != null && totalTimeAtStopQtyTotalTime != null;

  @override
  Widget build(BuildContext context) {
    context.read<StopAddValidationCubit>().timeValidationState(isValid());
    return BlocListener<StopAddCubit, DateTime>(
      listener: (context, state) async {
        var result = await widget.stopAddCallback(
            lineUnitId: widget.selectedLineUnit.id,
            productionBasicDataId: widget.productionBasicId,
            stopCurrentDefinitionId: widget.selectedStop.id,
            stopType: widget.selectedStop.stopTypeOf,
            averageTimeAtStopQtyAverageTime: widget.selectedStop.averageTime,
            qtyAtStopQtyTotalTime: qtyAtStopQtyTotalTime!.toInt(),
            totalTimeAtStopQtyTotalTime: totalTimeAtStopQtyTotalTime,
            claims: context.read<StopClaimCubit>().state.stopClaims
          );
        if (result) {
          Navigator.pop(context);
        }
      },
      child: Column(
        children: [
          NumberInput(
            key: const ValueKey('StopQtyTotalTime_Quantidade'),
            label: "Quantidade",
            allowDecimal: false,
            value: qtyAtStopQtyTotalTime,
            onChanged: (newValue) {
              setState(() {
                qtyAtStopQtyTotalTime = newValue;
              });
            },
          ),
          const SizedBox(height: 10),
          NumberInput(
            key: const ValueKey('StopQtyTotalTime_Tempo'),
            label: "Tempo Total (min)",
            allowDecimal: true,
            value: totalTimeAtStopQtyTotalTime,
            onChanged: (newValue) {
              setState(() {
                totalTimeAtStopQtyTotalTime = newValue;
              });
            },
          )
           
        ],
      ),
    );
  }
}
